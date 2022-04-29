CREATE or replace function reformat_ip (ip TEXT) returns text 
LANGUAGE plpgSQL
AS $$
DECLARE 
	ip_arr int[] := '{}';
	bin_ip_str text := '';
BEGIN
	ip_arr = concat('{',replace(ip, '.', ','),'}')::int[];
	FOR byte IN 1..3 LOOP
		bin_ip_str = concat(bin_ip_str, (ip_arr[byte]::bit(8))::text, '.');
	END LOOP;
	bin_ip_str = concat(bin_ip_str, (ip_arr[4]::bit(8))::text);
	
	return bin_ip_str;
	
END $$;


CREATE or replace function reformat_ip_cntry (cntry TEXT) returns text[]
LANGUAGE plpgSQL
AS $$
DECLARE 
	ip_arr text[] := '{}';
	bin_ip_str text := '';
	ip_split text[] = '{}';
	fin_ip_arr text[] = '{}';
	len int = (SELECT COUNT(ip) from task3 where country LIKE cntry);
BEGIN
	ip_arr = (SELECT array_agg(ip) from task3 where country LIKE cntry);
	fin_ip_arr = (SELECT array_agg(ip) from task3 where country LIKE cntry);
	
	FOR i in 1..len LOOP
		ip_split = concat('{',replace(ip_arr[i], '.', ','),'}')::int[];
		
		FOR byte IN 1..3 LOOP
			bin_ip_str = concat(bin_ip_str, (ip_split[byte]::int::bit(8))::text, '.');
		END LOOP;
		bin_ip_str = concat(bin_ip_str, (ip_split[4]::int::bit(8))::text);
		fin_ip_arr[i] = bin_ip_str;
		bin_ip_str = '';
	END LOOP;
	return fin_ip_arr;
END $$;


CREATE or replace function next_id() returns int
LANGUAGE plpgSQL
AS $$
DECLARE 
	n int = (SELECT max(task3.id) from task3);
BEGIN
	if (SELECT array_agg(task3.id) from task3) is null then return 0; end if;
	for i in 0..n+1 loop
		if i not in (SELECT task3.id from task3) then return(i); end if;
	end loop;
END $$;

CREATE or replace PROCEDURE fill_table (n int) 
LANGUAGE plpgSQL
AS $$
DECLARE
	mac_add text;
	ip text;
	countries text[] = '{Russian Federation, Latvia, Germany, Egypt, Spain,Italy,Norway,Litva,Angola,Ukraine}';
	country text;
	"date" date;
BEGIN
	FOR i in 0..n-1 LOOP
		ip = concat(floor(random()*256)::text, '.',floor(random()*256)::text, '.',
					floor(random()*256)::text, '.',floor(random()*256)::text);
		mac_add = concat(to_hex(floor(random()*256)::int)::text, ':',to_hex(floor(random()*256)::int)::text, ':',
						to_hex(floor(random()*256)::int)::text, ':',to_hex(floor(random()*256)::int)::text, ':',
						to_hex(floor(random()*256)::int)::text, ':',to_hex(floor(random()*256)::int)::text);
		country = countries[floor(random()*10)+1];
		"date" = NOW() + (random() * (NOW()+'100 days' - NOW())) + '20 days';
		INSERT INTO task3 (id, mac_add, ip, country, date) VALUES (next_id(), mac_add, ip, country, date);
	END LOOP;
END $$;



DROP TABLE IF EXISTS task3;
CREATE TABLE task3
(id INT PRIMARY KEY NOT NULL,
mac_add TEXT NOT NULL,
ip TEXT NOT NULL,
country TEXT NOT NULL,
date DATE NOT NULL);

call fill_table(100);

select * from task3;