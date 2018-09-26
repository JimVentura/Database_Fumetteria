CREATE TABLE `cliente` (
  `CodiceCliente` int(11) NOT NULL,
  `Nome` varchar(45) NOT NULL,
  `Cognome` varchar(45) NOT NULL,
  `DataNascita` date NOT NULL,
  `Email` varchar(45) NOT NULL,
  PRIMARY KEY (`CodiceCliente`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `genere` (
  `CodiceGenere` int(11) NOT NULL,
  `Nome` varchar(45) NOT NULL,
  PRIMARY KEY (`CodiceGenere`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `serie` (
  `CodiceSerie` int(11) NOT NULL,
  `Nome` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`CodiceSerie`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `fornitore` (
  `CodiceFornitore` int(11) NOT NULL,
  `RagioneSociale` varchar(45) NOT NULL,
  `PIVA` VARCHAR(45) NOT NULL,
  `Telefono` varchar(45)DEFAULT NULL,
  `Email` varchar(45) DEFAULT NULL,
  `Via` varchar(45) NOT NULL,
  `Civico` varchar(45) NOT NULL,
  `Citta` varchar(45) NOT NULL,
  `Cap` varchar(45) NOT NULL,
  PRIMARY KEY (`CodiceFornitore`),
  UNIQUE KEY `RagioneSociale_UNIQUE` (`RagioneSociale`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `contocorrente` (
  `Iban` VARCHAR(45) NOT NULL,
  `Titolare` varchar(45) NOT NULL,
  `Fornitore` int(11) DEFAULT NULL,
  PRIMARY KEY (`Iban`),
  FOREIGN KEY `fornitore1`(`Fornitore`) REFERENCES `fornitore` (`CodiceFornitore`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `modalitapagamento` (
  `IDPagamento` int(11) NOT NULL,
  `Termine` Int NOT NULL,
  `Descrizione` varchar(45) NOT NULL,
  PRIMARY KEY (`IDPagamento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `fattura` (
  `Fattura` int(11) NOT NULL,
  `DataFattura` date NOT NULL,
  `Fornitore` int(11) NOT NULL,
  `IDPagamento` int(11) NOT NULL,
  PRIMARY KEY (`DataFattura`,`Fornitore`,`Fattura`),
  FOREIGN KEY `fattura1`(`Fornitore`) REFERENCES `fornitore` (`CodiceFornitore`),
  FOREIGN KEY `fattura2`(`IDPagamento`) REFERENCES `modalitapagamento` (`IDPagamento`) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `notavendita` (
  `NotaVendita` int(11) NOT NULL AUTO_INCREMENT,
  `DataNota` date NOT NULL,
  `Cliente` int(11) DEFAULT NULL,
  PRIMARY KEY (`NotaVendita`,`DataNota`),
  FOREIGN KEY `notavendita1`(`Cliente`) REFERENCES `cliente` (`CodiceCliente`) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `ordine` (
  `NumeroOrdine` int(11) NOT NULL AUTO_INCREMENT,
  `DataOrdine` date NOT NULL,
  `StatoOrdine` tinyint(4) NOT NULL,
  `Cliente` int(11) NOT NULL,
  PRIMARY KEY (`NumeroOrdine`,`DataOrdine`),
  FOREIGN KEY `ordine1`(`Cliente`) REFERENCES `cliente` (`CodiceCliente`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `tessera` (
  `NumeroTessera` int(11) NOT NULL AUTO_INCREMENT,
  `TipoTessera` varchar(45) NOT NULL,
  `ScontoTessera` decimal(10,2) NOT NULL,
  `DataInizio` date NOT NULL,
  `DataFine` date NOT NULL,
  `Cliente` int(11) NOT NULL,
  PRIMARY KEY (`NumeroTessera`),
  FOREIGN KEY `tessera1`(`Cliente`) REFERENCES `cliente` (`CodiceCliente`) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `articolo` (
  `CodiceArticolo` int(11) NOT NULL AUTO_INCREMENT,
  `Nome` varchar(100) NOT NULL,
  `PrezzoAcquisto` decimal(65,2) NOT NULL DEFAULT '0.00',
  `PrezzoVendita` decimal(65,2) NOT NULL DEFAULT '0.00',
  `DataPubblicazione` date NOT NULL,
  `Disponibilita` int(11) NULL DEFAULT 0,
  `Volume` int(11) DEFAULT NULL,
  `Autore` varchar(50) DEFAULT NULL,
  `Categoria` varchar(45) NOT NULL,
  `Descrizione` varchar(150) DEFAULT NULL,
  `Eta` int(11) DEFAULT NULL,
  `CasaEditrice` varchar(45) DEFAULT NULL,
  `Serie` int(11) NOT NULL,
  `Genere1` int(11) NOT NULL,
  `Genere2` int(11) DEFAULT NULL,
  `Genere3` int(11) DEFAULT NULL,
  PRIMARY KEY (`CodiceArticolo`),
  FOREIGN KEY `articolo1`(`Serie`) REFERENCES `serie` (`CodiceSerie`),
  FOREIGN KEY `articolo2`(`Genere1`) REFERENCES `genere` (`CodiceGenere`),
  FOREIGN KEY `articolo3`(`Genere2`) REFERENCES `genere` (`CodiceGenere`),
  FOREIGN KEY `articolo4`(`Genere3`) REFERENCES `genere` (`CodiceGenere`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

create table `acquisto`
(
  `NumeroFattura` int(11) NOT NULL REFERENCES `fattura`(`Fattura`),
    `DataFattura` Date NOT NULL REFERENCES `fattura`(`DataFattura`),
    `Fornitore` int(11) NOT NULL REFERENCES `fattura`(`Fornitore`),
    `Articolo` int(11) NOT NULL REFERENCES `articolo`(`CodiceArticolo`),
    `Quantita` int(11) NOT NULL,
    PRIMARY KEY (`NumeroFattura`,`DataFattura`,`Fornitore`,`Articolo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table `vendita`
(
  `NotaVendita` INT(11) NOT NULL REFERENCES `notavendita` (`NotaVendita`),
  `DataNota` DATE NOT NULL REFERENCES `notavendita` (`DataNota`),
  `Articolo` int(11) NOT NULL REFERENCES `articolo` (`CodiceArticolo`),
  `Quantita` int(11) NOT NULL,
  PRIMARY KEY (`NotaVendita`,`DataNota`,`Articolo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table `ordinearticolo`
(
  `Ordine` int(11) NOT NULL REFERENCES `ordine` (`NumeroOrdine`),
  `DataOrdine` DATE NOT NULL REFERENCES `ordine` (`DataOrdine`),
  `Articolo` int(11) NOT NULL REFERENCES `articolo` (`CodiceArticolo`),
  `Quantita` int(11) NOT NULL,
  PRIMARY KEY (`Ordine`,`DataOrdine`,`Articolo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
    


DROP TRIGGER IF EXISTS dispacquisti; 
DELIMITER $$
CREATE TRIGGER dispacquisti after INSERT ON `acquisto` for each row
begin
UPDATE articolo SET articolo.Disponibilita=articolo.Disponibilita+new.Quantita
WHERE new.Articolo=articolo.CodiceArticolo;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS dispvendita;
DELIMITER $$
CREATE TRIGGER dispvendita after INSERT ON `vendita` for each row
begin
UPDATE articolo SET articolo.Disponibilita=articolo.Disponibilita-new.Quantita
WHERE new.Articolo=articolo.CodiceArticolo;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS fedelta; 
DELIMITER $$
create trigger fedelta after insert on `notavendita` for each row 
begin
declare numvendite int(10);
declare tesserato int(10);
declare tipo char(255);

select count(*) into tesserato from tessera t where new.Cliente=t.Cliente;
if(tesserato=1)
then 
select TipoTessera into tipo from tessera t where new.Cliente=t.Cliente;
select count(*) into numvendite
from notavendita n
where new.Cliente=n.Cliente AND YEAR(DataNota)=YEAR(CURDATE()); 
if(numvendite=20)
then
update tessera set TipoTessera='GOLD' where new.Cliente=tessera.Cliente;
end if;
if(numvendite=10 and tipo<>'GOLD')
then
update tessera set tessera.TipoTessera='SILVER' where new.Cliente=tessera.Cliente;
end if;
end if;
end$$
DELIMITER ;



