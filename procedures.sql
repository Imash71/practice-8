CREATE OR REPLACE PROCEDURE upsert_contact(p_name VARCHAR, p_phone VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
   IF EXISTS (SELECT 1 FROM contacts WHERE name = p_name) THEN
       UPDATE contacts SET phone = p_phone WHERE name = p_name;
   ELSE
       INSERT INTO contacts(name, phone) VALUES (p_name, p_phone);
   END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_contact(p_value TEXT)
LANGUAGE plpgsql AS $$
BEGIN
   DELETE FROM contacts
   WHERE name = p_value OR phone = p_value;
END;
$$;

CREATE OR REPLACE PROCEDURE insert_many_users(
   p_names TEXT[],
   p_phones TEXT[]
)
LANGUAGE plpgsql AS $$
DECLARE
   i INT;
   wrong_data TEXT[] := ARRAY[]::TEXT[];
BEGIN
   FOR i IN 1..array_length(p_names, 1) LOOP
       IF p_phones[i] ~ '^[0-9]+$' AND length(p_phones[i]) >= 10 THEN
           CALL upsert_contact(p_names[i], p_phones[i]);
       ELSE
           wrong_data := array_append(wrong_data, p_names[i] || ':' || p_phones[i]);
       END IF;
   END LOOP;
   RAISE NOTICE 'Wrong data: %', wrong_data;
END;
$$;