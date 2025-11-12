-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Departments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Departments` (
  `DepartmentID` INT NOT NULL AUTO_INCREMENT,
  `DepartmentName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`DepartmentID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Faculties`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Faculties` (
  `idFaculty` INT NOT NULL AUTO_INCREMENT,
  `FacultytName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idFaculty`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`users` (
  `idusers` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(50) NOT NULL,
  `Surname` VARCHAR(50) NOT NULL,
  `Email` VARCHAR(50) NOT NULL,
  `PasswordHash` VARCHAR(50) NOT NULL,
  `Role` ENUM('Студент', 'Куратор', 'Администратор') NOT NULL,
  `GroupName` VARCHAR(20) NOT NULL,
  `Phone` VARCHAR(15) NOT NULL,
  `Departments_DepartmentID` INT NOT NULL,
  `Faculties_idFaculty` INT NOT NULL,
  PRIMARY KEY (`idusers`),
  INDEX `fk_users_Departments_idx` (`Departments_DepartmentID` ASC) VISIBLE,
  INDEX `fk_users_Faculties1_idx` (`Faculties_idFaculty` ASC) VISIBLE,
  CONSTRAINT `fk_users_Departments`
    FOREIGN KEY (`Departments_DepartmentID`)
    REFERENCES `mydb`.`Departments` (`DepartmentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_Faculties1`
    FOREIGN KEY (`Faculties_idFaculty`)
    REFERENCES `mydb`.`Faculties` (`idFaculty`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Projects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Projects` (
  `ProjectID` INT NOT NULL AUTO_INCREMENT,
  `ProjectName` VARCHAR(255) NOT NULL,
  `Description` TEXT NOT NULL,
  `ProjectType` ENUM('Исследовательский', 'Бизнес', 'Прикладной') NOT NULL,
  `LifecycleModel` ENUM('Каскадная', 'Спиральная', 'Поэтапная', 'NULL') NOT NULL,
  `Status` ENUM('Черновик', 'Активен', 'На проверке', 'Завершен', 'Архив') NOT NULL,
  `StartDate` DATETIME NOT NULL,
  `EndDate` DATETIME NOT NULL,
  `LeadStudentID` INT NOT NULL,
  `CuratorID` INT NOT NULL,
  PRIMARY KEY (`ProjectID`),
  INDEX `fk_Projects_users1_idx` (`LeadStudentID` ASC) VISIBLE,
  INDEX `fk_Projects_users2_idx` (`CuratorID` ASC) VISIBLE,
  CONSTRAINT `fk_Projects_users1`
    FOREIGN KEY (`LeadStudentID`)
    REFERENCES `mydb`.`users` (`idusers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Projects_users2`
    FOREIGN KEY (`CuratorID`)
    REFERENCES `mydb`.`users` (`idusers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ProjectMembers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ProjectMembers` (
  `ProjectMemberID` INT UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT,
  `RoleInProject` VARCHAR(45) NOT NULL,
  `Projects_ProjectID` INT NOT NULL,
  `users_idusers` INT NOT NULL,
  PRIMARY KEY (`ProjectMemberID`),
  UNIQUE INDEX `ProjectMemberID_UNIQUE` (`ProjectMemberID` ASC) VISIBLE,
  INDEX `fk_ProjectMembers_Projects1_idx` (`Projects_ProjectID` ASC) VISIBLE,
  INDEX `fk_ProjectMembers_users1_idx` (`users_idusers` ASC) VISIBLE,
  CONSTRAINT `fk_ProjectMembers_Projects1`
    FOREIGN KEY (`Projects_ProjectID`)
    REFERENCES `mydb`.`Projects` (`ProjectID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ProjectMembers_users1`
    FOREIGN KEY (`users_idusers`)
    REFERENCES `mydb`.`users` (`idusers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ProjectStages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ProjectStages` (
  `StageID` INT NOT NULL AUTO_INCREMENT,
  `Projects_ProjectID` INT NOT NULL,
  `StageName` VARCHAR(45) NOT NULL,
  `StageDescription` TEXT NOT NULL,
  `SequenceOrder` INT NOT NULL,
  `Deadline` DATETIME NOT NULL,
  `Status` ENUM('Не начат', 'В работе', 'Готов к проверке', 'Принято', 'На доработке') NOT NULL,
  PRIMARY KEY (`StageID`),
  INDEX `fk_ProjectStages_Projects1_idx` (`Projects_ProjectID` ASC) VISIBLE,
  CONSTRAINT `fk_ProjectStages_Projects1`
    FOREIGN KEY (`Projects_ProjectID`)
    REFERENCES `mydb`.`Projects` (`ProjectID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Tasks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Tasks` (
  `TaskID` INT NOT NULL AUTO_INCREMENT,
  `ProjectStages_StageID` INT NOT NULL,
  `Projects_ProjectID` INT NOT NULL,
  `TaskName` VARCHAR(45) NOT NULL,
  `Description` TEXT NOT NULL,
  `users_idusers` INT NOT NULL,
  `Status` ENUM('К выполнению', 'В работе', 'Выполнено', 'Проверено') NOT NULL,
  `CreatedAt` DATETIME NOT NULL,
  `UpdatedAt` DATETIME NOT NULL,
  PRIMARY KEY (`TaskID`),
  INDEX `fk_Tasks_ProjectStages1_idx` (`ProjectStages_StageID` ASC) VISIBLE,
  INDEX `fk_Tasks_Projects1_idx` (`Projects_ProjectID` ASC) VISIBLE,
  INDEX `fk_Tasks_users1_idx` (`users_idusers` ASC) VISIBLE,
  CONSTRAINT `fk_Tasks_ProjectStages1`
    FOREIGN KEY (`ProjectStages_StageID`)
    REFERENCES `mydb`.`ProjectStages` (`StageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Tasks_Projects1`
    FOREIGN KEY (`Projects_ProjectID`)
    REFERENCES `mydb`.`Projects` (`ProjectID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Tasks_users1`
    FOREIGN KEY (`users_idusers`)
    REFERENCES `mydb`.`users` (`idusers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TaskResults`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TaskResults` (
  `ResultID` INT NOT NULL AUTO_INCREMENT,
  `Tasks_TaskID` INT NOT NULL,
  `FileLink` VARCHAR(255) NOT NULL,
  `Filepath` VARCHAR(255) NOT NULL,
  `GitHubLink` VARCHAR(255) NOT NULL,
  `Comment` TEXT NOT NULL,
  `SubmittedAt` DATETIME NOT NULL,
  PRIMARY KEY (`ResultID`),
  INDEX `fk_TaskResults_Tasks1_idx` (`Tasks_TaskID` ASC) VISIBLE,
  CONSTRAINT `fk_TaskResults_Tasks1`
    FOREIGN KEY (`Tasks_TaskID`)
    REFERENCES `mydb`.`Tasks` (`TaskID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DocumentTemplates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`DocumentTemplates` (
  `TemplateID` INT NOT NULL AUTO_INCREMENT,
  `TemplateName` VARCHAR(45) NOT NULL,
  `ProjectType` ENUM('Исследовательский', 'Бизнес', 'Прикладной') NOT NULL,
  `FileLink` VARCHAR(45) NOT NULL,
  `ProjectStages_StageID` INT NOT NULL,
  PRIMARY KEY (`TemplateID`),
  INDEX `fk_DocumentTemplates_ProjectStages1_idx` (`ProjectStages_StageID` ASC) VISIBLE,
  CONSTRAINT `fk_DocumentTemplates_ProjectStages1`
    FOREIGN KEY (`ProjectStages_StageID`)
    REFERENCES `mydb`.`ProjectStages` (`StageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`GradesAndFeedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`GradesAndFeedback` (
  `FeedbackID` INT NOT NULL AUTO_INCREMENT,
  `Grade` INT NOT NULL,
  `Comment` TEXT NOT NULL,
  `FeedbackType` ENUM('Промежуточная', 'Финальная') NOT NULL,
  `CreatedAt` DATETIME NOT NULL,
  `Projects_ProjectID` INT NOT NULL,
  `ProjectStages_StageID` INT NOT NULL,
  `users_idusers` INT NOT NULL,
  PRIMARY KEY (`FeedbackID`),
  INDEX `fk_GradesAndFeedback_Projects1_idx` (`Projects_ProjectID` ASC) VISIBLE,
  INDEX `fk_GradesAndFeedback_ProjectStages1_idx` (`ProjectStages_StageID` ASC) VISIBLE,
  INDEX `fk_GradesAndFeedback_users1_idx` (`users_idusers` ASC) VISIBLE,
  CONSTRAINT `fk_GradesAndFeedback_Projects1`
    FOREIGN KEY (`Projects_ProjectID`)
    REFERENCES `mydb`.`Projects` (`ProjectID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GradesAndFeedback_ProjectStages1`
    FOREIGN KEY (`ProjectStages_StageID`)
    REFERENCES `mydb`.`ProjectStages` (`StageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GradesAndFeedback_users1`
    FOREIGN KEY (`users_idusers`)
    REFERENCES `mydb`.`users` (`idusers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
