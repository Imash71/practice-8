CREATE OR REPLACE FUNCTION search_contacts(p text)
RETURNS TABLE(name VARCHAR, phone VARCHAR) AS $$
BEGIN
   RETURN QUERY
   SELECT c.name, c.phone
   FROM contacts c
   WHERE c.name ILIKE '%' || p || '%'
      OR c.phone ILIKE '%' || p || '%';
END;
$$ LANGUAGE plpgsql;