import psycopg2
from faker import Faker

con = psycopg2.connect(database="customers", user="postgres", password="lenovo07092001", host="127.0.0.1", port="5432")
cur = con.cursor()
cur.execute('''CREATE TABLE CUSTOMER
       (ID INT PRIMARY KEY     NOT NULL,
       Name           TEXT    NOT NULL,
       Address            TEXT     NOT NULL,
       review        TEXT);''')
fake = Faker()
for i in range(1000000):
    print(i)
    cur.execute("INSERT INTO CUSTOMER (ID,Name,Address,review) VALUES ('"+ str(i)+"','"+fake.name()+"','"+fake.address()+"','"+fake.text()+"')")
    con.commit()


def parse(string):
    idx = string.find("..") + 2
    result = ""
    ch = string[idx]
    while ch != " ":
        result += ch
        idx += 1
        ch = string[idx]
    return result


def drop_indexes():
    cur.execute('''
        DROP INDEX IF EXISTS review_idx;
        DROP INDEX IF EXISTS id_idx;
        DROP INDEX IF EXISTS address_idx;
        DROP INDEX IF EXISTS name_idx;
        ''')


def queries():
    cur.execute('''
    EXPLAIN ANALYZE
    SELECT COUNT(id)
    FROM customer 
    WHERE id > 150000 AND review LIKE 'Teach worker matter value. Free approach source season billion four. Assume score clear can tax.
    Either produce base third wife think beautiful.' AND address LIKE '238 Wanda Road
    South Michael, DC 03566';
    ''')
    print("The total cost is:", parse(str(cur.fetchone())))

    cur.execute('''
    EXPLAIN ANALYZE
    SELECT COUNT(id)
    FROM customer 
    WHERE name LIKE 'Mark Andrews' AND address LIKE '238 Wanda Road
    South Michael, DC 03566' AND review LIKE 'Teach worker matter value. Free approach source season billion four. Assume score clear can tax.
    Either produce base third wife think beautiful.';
    ''')
    print("The total cost is:", parse(str(cur.fetchone())))

    cur.execute('''
    EXPLAIN ANALYZE
    SELECT COUNT(id)
    FROM customer 
    WHERE name LIKE 'Mark Andrews' AND address LIKE '238 Wanda Road South Michael, DC 03566' AND id > 150000;
    ''')
    print("The total cost is:", parse(str(cur.fetchone())))

    cur.execute('''
    EXPLAIN ANALYZE
    SELECT COUNT(id)
    FROM customer 
    WHERE id > 150000 AND review LIKE 'Teach worker matter value. Free approach source season billion four. Assume score clear can tax.
    Either produce base third wife think beautiful.' AND name LIKE 'Mark Andrews';
    ''')
    print("The total cost is:", parse(str(cur.fetchone())))


def indexes():
    cur.execute('''
    CREATE INDEX if not exists review_idx 
    ON customer USING hash (review);

    CREATE INDEX if not exists address_idx 
    ON customer USING gin (to_tsvector('english', address))
    WHERE address LIKE '238 Wanda Road South Michael, DC 03566';

    CREATE INDEX if not exists name_idx 
    ON customer USING gist (to_tsvector('english', name))
    WHERE name LIKE 'Mark Andrews';

    CREATE INDEX if not exists id_idx 
    ON customer USING btree (id);
    ''')


drop_indexes()
queries()
indexes()
print("\n")
queries()
