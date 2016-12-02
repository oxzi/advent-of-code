CREATE OR REPLACE FUNCTION keypad_a(pos INT, mov VARCHAR)
RETURNS INT
LANGUAGE PLPGSQL
AS $$
DECLARE
	p INT = pos;
	i INT;
	c VARCHAR;
BEGIN
	FOR i IN 1..char_length(mov) LOOP
		c = substring(mov from i for 1);
		CASE c
			WHEN 'U' THEN
				IF p > 3 THEN p = p - 3; END IF;
			WHEN 'D' THEN
				IF p < 7 THEN p = p + 3; END IF;
			WHEN 'L' THEN
				IF p NOT IN (1, 4, 7) THEN p = p - 1; END IF;
			WHEN 'R' THEN
				IF p NOT IN (3, 6, 9) THEN p = p + 1; END IF;
		END CASE;
	END LOOP;
	RETURN p;
END
$$;

CREATE OR REPLACE FUNCTION keypad_b(pos INT, mov VARCHAR)
RETURNS INT
LANGUAGE PLPGSQL
AS $$
DECLARE
	p INT = pos;
	i INT;
	c VARCHAR;
BEGIN
	FOR i IN 1..char_length(mov) LOOP
		c = substring(mov from i for 1);
		p = CASE
			WHEN c = 'U' AND p = 13 THEN 11
			WHEN c = 'U' AND p = 3 THEN 1
			WHEN c = 'U' AND (p BETWEEN 6 AND 8 OR p BETWEEN 10 AND 12) THEN p - 4
			WHEN c = 'D' AND p = 11 THEN 13
			WHEN c = 'D' AND p = 1 THEN 3
			WHEN c = 'D' AND (p BETWEEN 2 AND 4 OR p BETWEEN 6 AND 8) THEN p + 4
			WHEN c = 'L' AND p IN (3, 4, 6, 7, 8, 9, 11, 12) THEN p - 1
			WHEN c = 'R' AND p IN (2, 3, 5, 6, 7, 8, 10, 11) THEN p + 1
			ELSE p
		END;
	END LOOP;
	RETURN p;
END
$$;

CREATE OR REPLACE FUNCTION intToChar(val INT)
RETURNS VARCHAR
LANGUAGE PLPGSQL
AS $$
BEGIN
	IF val < 10 THEN
		RETURN to_char(val, '9');
	ELSE
		CASE val
			WHEN 10 THEN RETURN 'A';
			WHEN 11 THEN RETURN 'B';
			WHEN 12 THEN RETURN 'C';
			WHEN 13 THEN RETURN 'D';
		END CASE;
	END IF;
END
$$;

CREATE OR REPLACE FUNCTION get_keycode(part VARCHAR)
RETURNS VARCHAR
LANGUAGE PLPGSQL
AS $$
DECLARE
	p INT = 5;
	ret VARCHAR = '';
	amount INT;
	i INT;
	tmpCode VARCHAR;
BEGIN
	SELECT COUNT(*) - 1 INTO amount FROM mov_codes;
	FOR i IN 0..amount LOOP
		SELECT code INTO tmpCode FROM mov_codes LIMIT 1 OFFSET i;
		IF part = 'A' THEN
			p = keypad_a(p, tmpCode);
		ELSE
			p = keypad_b(p, tmpCode);
		END IF;
		ret = ret || intToChar(p);
	END LOOP;
	RETURN ret;
END
$$;

CREATE TABLE IF NOT EXISTS mov_codes (
	code VARCHAR
);
TRUNCATE TABLE mov_codes;

INSERT INTO mov_codes VALUES
	('ULL'), ('RRDDD'), ('LURDL'), ('UUUUD');

SELECT * FROM get_keycode('A') UNION SELECT * FROM get_keycode('B');