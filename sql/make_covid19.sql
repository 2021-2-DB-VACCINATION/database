-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema COVID19
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema COVID19
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `COVID19` DEFAULT CHARACTER SET utf8 ;
USE `COVID19` ;

-- -----------------------------------------------------
-- Table `COVID19`.`VACCINE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`VACCINE` (
  `Vnumber` INT NOT NULL,
  `Vname` VARCHAR(50) NOT NULL,
  `AgeCont` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`Vnumber`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `COVID19`.`SIDO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`SIDO` (
  `Code` INT NOT NULL,
  `Sido` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `COVID19`.`SIGUNGU`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`SIGUNGU` (
  `Code` INT NOT NULL,
  `SiGunGu` VARCHAR(10) NOT NULL,
  `sido` INT NOT NULL,
  PRIMARY KEY (`Code`),
  INDEX `fk_SIGUNGU_SIDO2_idx` (`sido` ASC) INVISIBLE,
  CONSTRAINT `fk_SIGUNGU_SIDO2`
    FOREIGN KEY (`sido`)
    REFERENCES `COVID19`.`SIDO` (`Code`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `COVID19`.`PERSON`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`PERSON` (
  `Ssn` CHAR(14) NOT NULL,
  `Name` VARCHAR(20) NOT NULL,
  `Phone` CHAR(13) NOT NULL,
  `Email` VARCHAR(30) NOT NULL,
  `Password` VARCHAR(30) NOT NULL,
  `Location` VARCHAR(40) NOT NULL,
  `age` INT NULL,
  `IsAuth` TINYINT NOT NULL DEFAULT 0,
  `Sigungu` INT NOT NULL,
  `Sido` INT NOT NULL,
  `x` FLOAT NOT NULL,
  `y` FLOAT NOT NULL,
  PRIMARY KEY (`Ssn`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE,
  INDEX `fk_PERSON_SIGUNGU1_idx` (`Sigungu` ASC) VISIBLE,
  INDEX `fk_PERSON_SIDO1_idx` (`Sido` ASC) VISIBLE,
  CONSTRAINT `fk_PERSON_SIGUNGU1`
    FOREIGN KEY (`Sigungu`)
    REFERENCES `COVID19`.`SIGUNGU` (`Code`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_PERSON_SIDO1`
    FOREIGN KEY (`Sido`)
    REFERENCES `COVID19`.`SIDO` (`Code`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `COVID19`.`HOSPITAL`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`HOSPITAL` (
  `Hnumber` VARCHAR(100) NOT NULL,
  `Hlocation` VARCHAR(64) NOT NULL,
  `Hname` VARCHAR(30) NOT NULL,
  `Other` VARCHAR(50) NULL,
  `Hphone` VARCHAR(20) NOT NULL,
  `x` FLOAT NULL,
  `y` FLOAT NULL,
  `Sigungucode` INT NOT NULL,
  `Sidocode` INT NOT NULL,
  PRIMARY KEY (`Hnumber`),
  INDEX `fk_HOSPITAL_SIGUNGU1_idx` (`Sigungucode` ASC) VISIBLE,
  INDEX `fk_HOSPITAL_SIDO1_idx` (`Sidocode` ASC) VISIBLE,
  CONSTRAINT `fk_HOSPITAL_SIGUNGU1`
    FOREIGN KEY (`Sigungucode`)
    REFERENCES `COVID19`.`SIGUNGU` (`Code`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_HOSPITAL_SIDO1`
    FOREIGN KEY (`Sidocode`)
    REFERENCES `COVID19`.`SIDO` (`Code`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `COVID19`.`RESERVATION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`RESERVATION` (
  `Rnumber` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Rdate1` DATETIME NOT NULL,
  `Rdate2` DATETIME NOT NULL,
  `IsVaccine` TINYINT UNSIGNED NOT NULL,
  `Ssn` CHAR(14) NOT NULL,
  `Vnumber` INT NOT NULL,
  `Hnumber` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Rnumber`),
  INDEX `fk_RESERVATION_PERSON1_idx` (`Ssn` ASC) INVISIBLE,
  INDEX `fk_RESERVATION_VACCINE1_idx` (`Vnumber` ASC) INVISIBLE,
  INDEX `fk_RESERVATION_HOSPITAL1_idx` (`Hnumber` ASC) VISIBLE,
  CONSTRAINT `fk_RESERVATION_PERSON1`
    FOREIGN KEY (`Ssn`)
    REFERENCES `COVID19`.`PERSON` (`Ssn`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_RESERVATION_VACCINE1`
    FOREIGN KEY (`Vnumber`)
    REFERENCES `COVID19`.`VACCINE` (`Vnumber`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_RESERVATION_HOSPITAL1`
    FOREIGN KEY (`Hnumber`)
    REFERENCES `COVID19`.`HOSPITAL` (`Hnumber`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `COVID19`.`HOSPITAL_VACCINE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`HOSPITAL_VACCINE` (
  `Hnumber` VARCHAR(100) NOT NULL,
  `Amount` INT NOT NULL,
  `Expiration` DATE NOT NULL,
  `Vnumber` INT NOT NULL,
  INDEX `fk_HOSPITAL_VACCINE_VACCINE1_idx` (`Vnumber` ASC) VISIBLE,
  PRIMARY KEY (`Vnumber`, `Hnumber`),
  CONSTRAINT `fk_HOSPITAL_VACCINE_VACCINE1`
    FOREIGN KEY (`Vnumber`)
    REFERENCES `COVID19`.`VACCINE` (`Vnumber`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_HOSPITAL_VACCINE_HOSPITAL2`
    FOREIGN KEY (`Hnumber`)
    REFERENCES `COVID19`.`HOSPITAL` (`Hnumber`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `COVID19`.`HOSPITAL_TIME`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`HOSPITAL_TIME` (
  `Number` VARCHAR(100) NOT NULL,
  `Start_Mon` CHAR(4) NULL,
  `Close_Mon` CHAR(4) NULL,
  `Start_Tue` CHAR(4) NULL,
  `Close_Tue` CHAR(4) NULL,
  `Start_Wed` CHAR(4) NULL,
  `Close_Wed` CHAR(4) NULL,
  `Start_Thu` CHAR(4) NULL,
  `Close_Thu` CHAR(4) NULL,
  `Start_Fri` CHAR(4) NULL,
  `Close_Fri` CHAR(4) NULL,
  `Start_Sat` CHAR(4) NULL,
  `Close_Sat` CHAR(4) NULL,
  `Start_Sun` CHAR(4) NULL,
  `Close_Sun` CHAR(4) NULL,
  `IsOpenHoliday` VARCHAR(45) NULL,
  `Lunch_Week` VARCHAR(45) NULL,
  PRIMARY KEY (`Number`),
  CONSTRAINT `fk_HOSPITAL_TIME_HOSPITAL1`
    FOREIGN KEY (`Number`)
    REFERENCES `COVID19`.`HOSPITAL` (`Hnumber`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `COVID19`.`PHARMACY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`PHARMACY` (
  `Pnumber` VARCHAR(100) NOT NULL,
  `Plocation` VARCHAR(64) NOT NULL,
  `Pname` VARCHAR(30) NOT NULL,
  `Pphone` VARCHAR(20) NULL,
  `Sidocode` INT NOT NULL,
  `Sigungucode` INT NOT NULL,
  `x` FLOAT NULL,
  `y` FLOAT NULL,
  PRIMARY KEY (`Pnumber`),
  INDEX `fk_PHARMACY_SIDO1_idx` (`Sidocode` ASC) VISIBLE,
  INDEX `fk_PHARMACY_SIGUNGU1_idx` (`Sigungucode` ASC) VISIBLE,
  CONSTRAINT `fk_PHARMACY_SIGUNGU1`
    FOREIGN KEY (`Sigungucode`)
    REFERENCES `COVID19`.`SIGUNGU` (`Code`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_PHARMACY_SIDO1`
    FOREIGN KEY (`Sidocode`)
    REFERENCES `COVID19`.`SIDO` (`Code`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `COVID19`.`PHARMACY_TIME`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`PHARMACY_TIME` (
  `Number` VARCHAR(100) NOT NULL,
  `Start_Mon` CHAR(4) NULL,
  `Close_Mon` CHAR(4) NULL,
  `Start_Tue` CHAR(4) NULL,
  `Close_Tue` CHAR(4) NULL,
  `Start_Wed` CHAR(4) NULL,
  `Close_Wed` CHAR(4) NULL,
  `Start_Thu` CHAR(4) NULL,
  `Close_Thu` CHAR(4) NULL,
  `Start_Fri` CHAR(4) NULL,
  `Close_Fri` CHAR(4) NULL,
  `Start_Sat` CHAR(4) NULL,
  `Close_Sat` CHAR(4) NULL,
  `Start_Sun` CHAR(4) NULL,
  `Close_Sun` CHAR(4) NULL,
  `IsOpenHoliday` VARCHAR(45) NULL,
  `Lunch_Week` VARCHAR(45) NULL,
  PRIMARY KEY (`Number`),
  CONSTRAINT `fk_HOSPITAL_TIME_PHARMACY10`
    FOREIGN KEY (`Number`)
    REFERENCES `COVID19`.`PHARMACY` (`Pnumber`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `COVID19` ;

-- -----------------------------------------------------
-- Placeholder table for view `COVID19`.`Pfizer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`Pfizer` (`Hnumber` INT, `Vname` INT, `Amount` INT);

-- -----------------------------------------------------
-- Placeholder table for view `COVID19`.`Morderna`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`Morderna` (`Hnumber` INT, `Vname` INT, `Amount` INT);

-- -----------------------------------------------------
-- Placeholder table for view `COVID19`.`Janssen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`Janssen` (`Hnumber` INT, `Vname` INT, `Amount` INT);

-- -----------------------------------------------------
-- Placeholder table for view `COVID19`.`AstraZeneca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`AstraZeneca` (`Hnumber` INT, `Vname` INT, `Amount` INT);

-- -----------------------------------------------------
-- Placeholder table for view `COVID19`.`reservation_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`reservation_info` (`Rnumber` INT, `Name` INT, `Vname` INT, `Hname` INT, `Rdate1` INT, `Rdate2` INT, `IsVaccine` INT);

-- -----------------------------------------------------
-- Placeholder table for view `COVID19`.`Rdate1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`Rdate1` (`Rnumber` INT, `Rdate` INT, `IsVaccine` INT, `Ssn` INT, `Vnumber` INT, `Hnumber` INT);

-- -----------------------------------------------------
-- Placeholder table for view `COVID19`.`Rdate2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`Rdate2` (`Rnumber` INT, `Rdate` INT, `IsVaccine` INT, `Ssn` INT, `Vnumber` INT, `Hnumber` INT);

-- -----------------------------------------------------
-- Placeholder table for view `COVID19`.`reservation_list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COVID19`.`reservation_list` (`Rnumber` INT, `Rdate` INT, `IsVaccine` INT, `Ssn` INT, `Vnumber` INT, `Hnumber` INT);

-- -----------------------------------------------------
-- View `COVID19`.`Pfizer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `COVID19`.`Pfizer`;
USE `COVID19`;
CREATE  OR REPLACE VIEW `Pfizer` AS
select hv.Hnumber, v.Vname, hv.Amount
from vaccine as v, hospital_vaccine as hv
where hv.Vnumber = v.Vnumber and Vname = 'Pfizer';

-- -----------------------------------------------------
-- View `COVID19`.`Morderna`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `COVID19`.`Morderna`;
USE `COVID19`;
CREATE  OR REPLACE VIEW `Morderna` AS
select hv.Hnumber, v.Vname, hv.Amount
from vaccine as v, hospital_vaccine as hv
where hv.Vnumber = v.Vnumber and v.Vname = 'Morderna';
select * from Morderna;

-- -----------------------------------------------------
-- View `COVID19`.`Janssen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `COVID19`.`Janssen`;
USE `COVID19`;
CREATE  OR REPLACE VIEW `Janssen` AS
select hv.Hnumber, v.Vname, hv.Amount
from vaccine as v, hospital_vaccine as hv
where hv.Vnumber = v.Vnumber and v.Vname = 'Janssen';
select * from Janssen;

-- -----------------------------------------------------
-- View `COVID19`.`AstraZeneca`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `COVID19`.`AstraZeneca`;
USE `COVID19`;
CREATE  OR REPLACE VIEW `AstraZeneca` AS
select hv.Hnumber, v.Vname, hv.Amount
from vaccine as v, hospital_vaccine as hv
where hv.Vnumber = v.Vnumber and v.Vname = 'AstraZeneca';
select * from AstraZeneca;

-- -----------------------------------------------------
-- View `COVID19`.`reservation_info`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `COVID19`.`reservation_info`;
USE `COVID19`;
CREATE  OR REPLACE VIEW `reservation_info` AS
select r.Rnumber, p.Name, v.Vname, H.Hname, r.Rdate1, r.Rdate2, r.IsVaccine
from person as p, reservation as r, vaccine as v, Hospital as h
where p.Ssn = r.Ssn and r.Hnumber = h.Hnumber and r.Vnumber = v.Vnumber;
select * from about_reservation;

-- -----------------------------------------------------
-- View `COVID19`.`Rdate1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `COVID19`.`Rdate1`;
USE `COVID19`;
CREATE  OR REPLACE VIEW `Rdate1` AS
select Rnumber, Rdate1 as Rdate, IsVaccine, Ssn, Vnumber, Hnumber
from reservation as r;

-- -----------------------------------------------------
-- View `COVID19`.`Rdate2`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `COVID19`.`Rdate2`;
USE `COVID19`;
CREATE  OR REPLACE VIEW `Rdate2` AS
select Rnumber, Rdate2 as Rdate, IsVaccine, Ssn, Vnumber, Hnumber
from reservation as r;

-- -----------------------------------------------------
-- View `COVID19`.`reservation_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `COVID19`.`reservation_list`;
USE `COVID19`;
CREATE  OR REPLACE VIEW `reservation_list` AS
select Rnumber, Rdate, IsVaccine, Ssn, Vnumber, Hnumber
from Rdate1 as r1
union
select * 
from Rdate2 as r2;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
