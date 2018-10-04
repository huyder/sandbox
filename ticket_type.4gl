MAIN

  DEFINE db_name   STRING

  IF num_args() != 1 THEN
    DISPLAY "Usage: ",arg_val(0), " <dbname>"
    EXIT PROGRAM
  END IF

  LET db_name = arg_val(1)
  LET db_name = DOWNSHIFT(db_name)

  CONNECT TO db_name

  CALL unload_ticket_type()
  CALL update_ticket_type()

END MAIN

FUNCTION unload_ticket_type()

  UNLOAD TO "ticket_type.unl" DELIMITER "|"
  SELECT * FROM ticket_type

END FUNCTION

FUNCTION update_ticket_type()

  DEFINE multi_jur CHAR(1)

  SELECT mj INTO multi_jur FROM site_config

  IF multi_jur = "N" THEN
    UPDATE ticket_type
       SET all_jurisdictions = "Y",
           jurisdiction = NULL
  ELSE
    UPDATE ticket_type
       SET all_jurisdictions = "N"

    UPDATE ticket_type
       SET all_jurisdictions = "Y"
     WHERE jurisdiction IS NULL OR jurisdiction = " "
  END IF

END FUNCTION
