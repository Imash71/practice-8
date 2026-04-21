import psycopg2
conn = psycopg2.connect(
   dbname="phonebook_db",
   user="postgres",
   password="12345",
   host="localhost",
   port="5432"
)
cur = conn.cursor()
cur.execute("CALL upsert_contact(%s, %s)", ("Imash", "87001112233"))
conn.commit()
cur.execute("SELECT * FROM contacts;")
print(cur.fetchall())
cur.close()
conn.close()