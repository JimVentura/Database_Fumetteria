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

DROP FUNCTION IF EXISTS Venduto;
DELIMITER $$ 
CREATE FUNCTION `Venduto`(CodiceArticolo INTEGER(10)) 
RETURNS int(11)
BEGIN 
DECLARE maxvendite int(11);
SELECT 
    sum(Quantita)
INTO maxvendite 
FROM
    vendita as v
WHERE
    CodiceArticolo = v.Articolo;
RETURN maxvendite; 
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS Scadenza;
DELIMITER $$ 
CREATE FUNCTION `Scadenza`(IDPagamento INTEGER(10),DataFattura DATE) 
RETURNS int(11)
BEGIN 
DECLARE termine int(11);
DECLARE datacor DATE;
DECLARE giornitrascorsi int(11);
DECLARE Scadenza int(11);
SELECT 
    m.Termine
INTO termine 
FROM
    modalitapagamento m
WHERE
    IDPagamento = m.IDPagamento;
SELECT CURDATE() INTO datacor;
SELECT DATEDIFF(datacor,DataFattura) INTO giornitrascorsi;
SELECT (termine-giornitrascorsi) INTO Scadenza;
RETURN Scadenza; 
END$$
DELIMITER ;



INSERT INTO `cliente` (`CodiceCliente`,`Nome`,`Cognome`,`DataNascita`,`Email` )
	VALUES(1,'Nicola','Cisternino','1995-01-12','nicola.cisternino@studenti.unipd.it'),
	(2,'Marco','Masiero','1992-10-06','marco.masiero@studenti.unipd.it'),
	(3,'Francesco','Sacchetto','1994-12-19','francesco.sacchetto@studenti.unipd.it'),
	(4,'Lucia','Fenu','1995-06-30','lucia.fenu@studenti.unipd.it'),
	(5,'Francesco','Pecile','1996-04-12','francesco.pecile@studenti.unipd.it'),
	(6,'Matteo','Depascale','1995-08-20','matteo.depascale@studenti.unipd.it'),
	(7,'Gianmarco','Pettenuzzo','1995-08-20','gianmarco.pettenuzzo@studenti.unipd.it'),
	(8,'Francesco','Battistella','1994-01-10','francesco.battistella@studenti.unipd.it'),
	(9,'Stefano','Nordio','1996-07-17','stefano.nordio@studenti.unipd.it'),
	(10,'Enrico','Tavian','1996-02-29','enrico.tavian@studenti.unipd.it'),
	(11,'Valentina','Bullo','1996-03-30','valentina.bullo@studenti.unipd.it'),
	(12,'Federico','Ballarin','1996-07-14','federico.ballarin@studenti.unipd.it'),
	(13,'Marco','Giollo','1996-09-15','marco.giollo@studenti.unipd.it'),
	(14,'Andrea','Giordani','1992-08-22','andrea.giordani.1@studenti.unipd.it'),
	(15,'Leonardo','Fiordigiglio','1990-07-22','leonardo.fiordigiglio@studenti.unipd.it'),
	(16,'Niccolo','Salmistraro','1989-03-03','niccolo.salmistraro@studenti.unipd.it');


INSERT INTO `genere`(`CodiceGenere`,`Nome`)
	VALUES (1,'Ecchi'),
	(2,'Harem'),
	(3,'Shonen'),
	(4,'Fantasy'),
	(5,'Mecha'),
	(6,'Sentimentale'),
	(7,'Commedia'),
	(8,'Sportivo'),
	(9,'Avventura'),
	(10,'Azione'),
	(11,'Tazza'),
	(12,'Maglietta'),
	(13,'Poster'),
	(14,'Cuscino'),
	(15,'Hoodie'),
	(16,'Intero'),
	(17,'Montabile'),
	(18,'DVD Movie'),
	(19,'DVD ANIME'),
	(20,'DVD OAV ANIME'),
	(21,'Portachiavi'),
	(22,'Carte da Gioco');

INSERT INTO `fornitore` (`CodiceFornitore`,`RagioneSociale`,`PIVA`,`Telefono`,`Email`,`Via`,`Civico`,`Citta`,`Cap`)
	VALUES (1,'GAME TRADE','IT12839231837','0492748122','gametrade@supporto.com','Via degli albori','4','Modena','47383'),
	(2,'STAR COMICS','IT32719249822',NULL,'starcomics@supporto.it','Via Carlo Alberto','17','Roma','16450'),
	(3,'PLANET MANGA','IT44381495932',NULL,'planetmanga@help.it','Piazza Vittorio Emanuele','3','Milano','54849'),
	(4,'MARVEL ITALIA','IT39204303843','0327483919',NULL,'Via Arborea','90','Bologna','48493'),
	(5,'DC COMICS','IT73182304921','0497484618','dccomics@support.com','Piazza Duca degli Abruzzi','31','Torino','93939'),
	(6,'J-POP','IT48309493002',NULL,'jpop@info.it','Via Giuseppe Garibaldi','76','Padova','35127'),
	(7,'KAPPA EDIZIONI','IT83930208492','0797219837',NULL,'Via Ubaldo Ugolino','54','Catania','38292'),
	(8,'SQUARE ENIX','IT23839849325',NULL,'squareenix@support.com','Piazza dei Valori','41','Monza','48939'),
	(9,'BANDAI','IT23923020131',NULL,'bandainamco@support.com','Via Mandaneo','75','Verona','84319'),
	(10,'DYNIT','IT73421812932','0384018492','dynit@info.it','Piazza la Bomba e Fuggi','45','Roma','15515');

INSERT INTO `tessera` (`NumeroTessera`,`TipoTessera`,`ScontoTessera`,`DataInizio`,`DataFine`,`Cliente`)
	VALUES (1,'GOLD',0.15,'2016-08-18','2017-08-18',3),
	(2,'BRONZE',0.10,'2017-02-17','2018-02-17',1),
	(3,'SILVER',0.10,'2017-02-18','2018-02-18',15),
	(4,'BRONZE',0.05,'2017-03-07','2018-03-07',4),
	(5,'BRONZE',0.05,'2017-03-14','2018-03-14',9),
	(6,'GOLD',0.15,'2017-04-02','2017-04-02',11),
	(7,'BRONZE',0.05,'2017-04-09','2018-04-09',2),
	(8,'SILVER',0.10,'2017-04-23','2018-04-23',7);

INSERT INTO `contocorrente` (`Iban`,`Titolare`,`Fornitore`)
	VALUES ('IT88T489284485462811746593092','Marco Marcello Lupoi',1),
	('IT88T8475640573859483738529','Giovanni Bovini',2),
	('IT88T959471756091648532401910','Max Bunker',3),
	('IT88T7469395610492648591143','Stan Lee',4),
	('IT88T4840327810742849501084','Malcom Wheeler Nicholson',5),
	('IT88T7849473948394884839372','Francesco Meo',6),
	('IT88T4849728948593830302993','Andrea Baricordi',7),
	('IT88T4839473973622987338301','Yosuke Matsuda',8),
	('IT88T7349372128941924984194','Kazunori Ueno',9),
	('IT88T4819482490000481249219','Francesco Di Sanzo',10);

INSERT INTO `modalitapagamento` (`IDPagamento`,`Termine`,`Descrizione`)
VALUES (1,30,'Bonifico Bancario 30gg'),
(2,60,'Bonifico Bancario 60gg'),
(3,90,'Bonifico Bancario 90gg'),
(4,30,'Ri.Ba. a 30gg'),
(5,60,'Ri.Ba. a 60gg');

INSERT INTO `serie` (`CodiceSerie`,`Nome`)
VALUES (1,'One Piece'),
(2,'Naruto'),
(3,'Bleach'),
(4,'Shingeki no Kyojin'),
(5,'Superman'),
(6,'Capitan America'),
(7,'Dragon Ball'),
(8,'The Flash'),
(9,'Warhammer 40000'),
(10,'Spiderman'),
(11,'Yugioh'),
(12,'Dungeons & Dragons');

	
INSERT INTO `articolo` (`Nome`,`PrezzoAcquisto`, `PrezzoVendita`,`DataPubblicazione`,`Volume`,`Autore`,`Categoria`,`CasaEditrice`,`Serie`,`Genere1`,`Genere2`,`Genere3`)
VALUES ('Romance Dawn, l alba di una grande avventura',3.00,4.30,'2008-02-08',1,'Eichiro Oda','manga','Star Comics',1,9,10,3),
('Versus! La banda del pirata Bagy',3.00,4.30,'2008-03-20',2,'Eichiro Oda','manga','Star Comics',1,9,10,3),
('Un tipino a modo',3.00,4.30,'2008-04-21',3,'Eichiro Oda','manga','Starcomics',1,9,10,3),
('Un colosseo di canaglie',3.00,4.30,'2016-10-19',71,'Eichiro Oda','manga','Star Comics',1,9,10,3),
('I dimenticati di Dressrosa',3.00,4.30,'2017-01-18',72,'Eichiro Oda','manga','Star Comics',1,9,10,3),
('Operazione Dressrosa O.S.S.',3.00,4.30,'2017-04-19',73,'Ecihiro Oda','manga','Star Comics',1,9,10,3),
('Ti starò sempre vicino',3.00,4.30,'2017-08-20',74,'Eichiro Oda','manga','Star Comics',1,9,10,3),
('Naruto Uzumaki!',2.90,4.30,'2003-04-03',1,'Masashi Kishimoto','manga','Planet Manga',2,9,10,3),
('Il peggior cliente',2.90,4.30,'2003-04-17',2,'Masashi Kishimoto','manga','Planet Manga',2,9,10,3),
('In nome del sogno!',2.90,4.30,'2003-05-22',3,'Masashi Kishimoto','manga','Planet Manga',2,9,10,3),
('Il ponte dell eroe!',2.90,4.30,'2003-06-19',4,'Masashi Kishimoto','manga','Planet Manga',2,9,10,3),
('Gli sfidanti!',2.90,4.30,'2003-07-17',5,'Masashi Kishimoto','manga','Planet Manga',2,9,10,3),
('Mi piacete un sacco',2.90,4.30,'2015-11-05',71,'Masashi Kishimoto','manga','Planet Manga',2,9,10,3),
('Uzumaki Naruto!',2.90,4.30,'2016-04-16',72,'Masashi Kishimoto','manga','Planet Manga',2,9,10,3),
('Naruto e l Eremita delle Sei Vie',2.90,4.30,'2015-06-04',70,'Masashi Kishimoto','manga','Planet Manga',2,9,10,3),
('L inizio della primavera rossa',2.90,4.30,'2015-03-05',69,'Masashi Kishimoto','manga','Planet Manga',2,9,10,3),
('Spiderman, l inizio',2.50,5.00,'1973-10-15',1,'Stan Lee','fumetto','Marvel Comics',10,10,4,9),
('Spiderman, potere e responsabilita',2.50,5.00,'1973-11-15',2,'Stan Lee','fumetto','Marvel Comics',10,10,4,9),
('Spiderman, la crisi del ragno',2.50,5.00,'1973-12-15',3,'Stan Lee','fumetto','Marvel Comics',10,10,4,9),
('Spiderman Vs Venom',2.50,5.00,'1974-01-17',4,'Stan Lee','fumetto','Marvel Comics',10,10,4,9),
('Spiderman, torna la pace',2.50,5.00,'1974-02-18',5,'Stan Lee','fumetto','Marvel Comics',10,10,4,9),
('Spiderman, l’eroe di cui abbiamo bisogno',2.50,5.00,'1974-03-15',6,'Stan Lee','fumetto','Marvel Comics',10,10,4,9),
('Flash, la nascita del velocista',3.00,5.50,'2016-10-22',1,'Robert Kanigher','fumetto','DC Comics',8,10,9,6),
('Flash, niente e lasciato al caso',3.00,5.50,'2016-11-22',2,'Robert Kanigher','fumetto','DC Comics',8,10,9,6),
('Flash, tutta una finzione',3.00,5.50,'2016-12-22',3,'Robert Kanigher','fumetto','DC Comics',8,10,9,6),
('Flash, l uomo dietro tutto questo',3.00,5.50,'2016-11-22',4,'Robert Kanigher','fumetto','DC Comics',8,10,9,6),
('Flash, niente e lasciato al caso',3.00,5.50,'2017-02-22',5,'Robert Kanigher','fumetto','DC Comics',8,10,9,6),
('Flash, Vs AntiFlash',3.00,5.50,'2017-03-25',6,'Robert Kanigher','fumetto','DC Comics',8,10,9,6),
('Flash, il vero nemico e Zoom',3.00,5.50,'2017-04-27',7,'Robert Kanigher','fumetto','DC Comics',8,10,9,6),
('Flash, un nuovo nemico Savitar',3.00,5.50,'2017-05-29',2,'Robert Kanigher','fumetto','DC Comics',8,10,9,6),
('Flash, l’eroe e’ un cattivo',3.00,5.50,'2017-06-29',2,'Robert Kanigher','fumetto','DC Comics',8,10,9,6);

INSERT INTO `articolo` (`Nome`,`PrezzoAcquisto`,`PrezzoVendita`,`DataPubblicazione`,`Categoria`,`Descrizione`,`eta`,`CasaEditrice`,`Serie`,`Genere1`)
VALUES ('Kurosaki Ichigo Battle Version',12.25,20.50,'2017-04-23','ActionFigure','Kurosaki Ichigo pronto a sferrare Getsuga Tensho',14,'FigureForLife',3,16),
('Rukia Kuchiki Summer Edition',15.00,25.50,'2017-07-15','ActionFigure','Rukia Kuchiki al mare mentre i suoi compagni a studiare',18,'Lollipop',3,17),
('Zoro Battle Version',18.00,30.50,'2016-09-13','ActionFigure','Rorona Zoro nella sfida con Mihawk',7,'Bandai',1,16),
('Sanji Battle Version',21.00,41.50,'2016-09-13','ActionFigure','Sanji scatena il Diable Jamble',7,'Bandai',1,16),
('Naruto Jutsu moltiplicazione',15.00,26.50,'2015-10-01','ActionFigure','15 copie di Naruto in posizioni esilaranti',10,'Bandai',2,17),
('Superman vs Doomsdale',75.00,145.00,'2017-06-13','ActionFigure','Sfida tra Superman e Doomsdale',18,'DC Comics',5,16);

INSERT INTO `articolo` (`Nome`,`PrezzoAcquisto`,`PrezzoVendita`,`DataPubblicazione`,`Categoria`,`Descrizione`,`eta`,`CasaEditrice`,`Serie`,`Genere1`)
VALUES ('Capitan America',1.00,2.50,'2016-06-29','Gadget','Poster Capitan America Civil War',6,'Marvel Comics',6,13),
('Superman e Justice League',1.00,2.50,'2017-06-29','Gadget','Superman al comando della Justice League',6,'DC Comics',5,13),
('Felpa Gigante corazzato',30.00,45.00,'2016-12-19','Gadget','Taglia unica Edizione Titano Corazzato',14,'DressFan',4,15),
('Goku ssj blue',10.00,18.00,'2017-05-15','Gadget','Tazza di Goku che cambia colore con bevanda calda',3,'Kawabonga Toys',7,11),
('Portachiavi di Naruto',1.00,5.00,'2017-01-16','Gadget','Portachiavi un acciaio con la foto di Naruto',3,'Kawabonga Toys',2,21),
('Cuscino One Piece','4.00','10.00','2107-03-12','Gadget','Cuscino della ciurma di cappello di paglia',3,'Kawabonga Toys',1,14);

INSERT INTO `articolo` (`Nome`,`PrezzoAcquisto`,`PrezzoVendita`,`DataPubblicazione`,`Categoria`,`Descrizione`,`eta`,`CasaEditrice`,`Serie`,`Genere1`,`Genere2`)
VALUES ('Mazzo Eroe Elementale',2.00,5.50,'2015-09-20','Giochi','Carte collezionabili per duellare di tipo Eroe',6,'Konami',11,22,4),  
('Mazzo Drago Supremo',2.00,5.50,'2015-09-20','Giochi','Carte collezionabili per duellare di tipo Eroe',6,'Konami',11,22,4),  
('Mazzo Drago Apocalisse',2.00,5.50,'2016-04-20','Giochi','Carte collezionabili per duellare di tipo Eroe',6,'Konami',11,22,4),   
('Carte Rivolta Mecha',2.00,5.50,'2016-04-20','Giochi','Carte collezionabili per duellare di tipo Eroe',6,'Konami',11,22,4),  
('Carte Crisalide Insetto',2.00,5.50,'2016-04-20','Giochi','Carte collezionabili per duellare di tipo Eroe',6,'Konami',11,22,4);  

INSERT INTO `articolo` (`Nome`,`PrezzoAcquisto`,`PrezzoVendita`,`DataPubblicazione`,`Categoria`,`Descrizione`,`eta`,`CasaEditrice`,`Serie`,`Genere1`,`Genere2`,`Genere3`)
VALUES ('Triumvirate of the Imperium',35.00,69.99,'2016-04-03','Giochi','Gioco da tavolo che sfrutta i modellini warhammer',12,'Games Workshop',9,5,4,17),
('Magnus the Red',50.00,104.99,'2016-04-03','Giochi','Gioco da tavolo che sfrutta i modellini warhammer',12,'Games Workshop',9,5,4,17),
('Triumvirate of Ynnead',20.00,59.99,'2016-05-07','Giochi','Gioco da tavolo che sfrutta i modellini warhammer',12,'Games Workshop',9,5,4,17),
('Tau Empire Commander',15.00,40.00,'2016-05-18','Giochi','Gioco da tavolo che sfrutta i modellini warhammer',12,'Games Workshop',9,5,4,17);

INSERT INTO `articolo` (`Nome`,`PrezzoAcquisto`,`PrezzoVendita`,`DataPubblicazione`,`Categoria`,`Descrizione`,`CasaEditrice`,`Serie`,`Genere1`,`Genere2`,`Genere3`)
VALUES ('Naruto Movie 1',5.00,10.00,'2006-01-09','DVD','Il libro dei ninja della principessa della neve','Toei Animation',2,9,10,3),
('Naruto Movie 2',5.00,10.00,'2007-01-09','DVD','Le rovine immaginarie al centro della terra','Toei Animation',2,9,10,3),
('Naruto Movie 3',5.00,10.00,'2008-01-09','DVD','La rivolta animale dell isola della luna crescente','Toei Animation',2,9,10,3),
('Naruto Movie 4',5.00,10.00,'2009-01-09','DVD','La morte di Naruto','Toei Animation',2,9,10,3),
('Naruto Movie 5',5.00,10.00,'2010-01-09','DVD','Kizuna (Il Legame)','Toei Animation',2,9,10,3),
('Naruto Movie 6',5.00,10.00,'2011-05-09','DVD','Eredi Della Volontà Del Fuoco','Toei Animation',2,9,10,3),
('Naruto Movie 7',5.00,10.00,'2012-01-09','DVD','The Lost Tower','Toei Animation',2,9,10,3),
('Naruto Movie 8',5.00,10.00,'2013-01-09','DVD','Blood Prison','Toei Animation',2,9,10,3),
('One Piece Movie 1',4.50,9.00,'2004-10-13','DVD','Per tutto l oro del mondo','Toei Animation',1,9,10,3),
('One Piece Movie 2',4.50,9.00,'2005-10-23','DVD','Avventura all Isola Spirale','Toei Animation',1,9,10,3),
('One Piece Movie 3',4.50,9.00,'2006-10-19','DVD','Il tesoro del re','Toei Animation',1,9,10,3),
('One Piece Movie 4',4.50,9.00,'2007-11-30','DVD','Trappola mortale','Toei Animation',1,9,10,3),
('One Piece Movie 5',4.50,9.00,'2008-12-03','DVD','La spada delle sette stelle','Toei Animation',1,9,10,3),
('One Piece Movie 6',4.50,9.00,'2009-09-30','DVD','L isola segreta del barone Omatsuri','Toei Animation',1,9,10,3),
('One Piece Movie 7',4.50,9.00,'2010-08-19','DVD','I misteri dell isola meccanica','Toei Animation',1,9,10,3),
('One Piece Movie 8',4.50,9.00,'2011-12-23','DVD','Un amicizia oltre i confini del mare','Toei Animation',1,9,10,3),
('One Piece Movie 9',4.50,9.00,'2012-10-30','DVD','Il miracolo dei ciliegi in fiore','Toei Animation',1,9,10,3),
('One Piece Movie 10',4.50,9.00,'2013-09-10','DVD','Avventura sulle isole volanti','Toei Animation',1,9,10,3);



INSERT INTO `fattura` (`Fattura`,`DataFattura`,`Fornitore`,`IDPagamento`)
VALUES (7,'2017-01-31',2,3),
(40,'2017-01-31',3,3),
(90,'2017-01-31',4,4),
(16,'2017-01-31',5,4),
(13,'2017-01-31',7,5),
(101,'2017-02-28',2,2),
(76,'2017-02-28',9,1),
(196,'2017-02-28',4,4),
(176,'2017-03-31',6,3),
(189,'2017-03-31',10,2),
(240,'2017-03-31',9,1),
(174,'2017-04-30',1,2),
(441,'2017-04-30',10,2),
(400,'2017-04-30',2,2),
(211,'2017-04-30',7,5),
(1105,'2017-05-31',6,2),
(211,'2017-05-31',1,2);


INSERT INTO `acquisto` (`NumeroFattura`,`DataFattura`,`Fornitore`,`Articolo`,`Quantita`)
VALUES (7,'2017-01-31',2,1,10),
(7,'2017-01-31',2,2,10),
(7,'2017-01-31',2,3,10),
(7,'2017-01-31',2,4,10),
(7,'2017-01-31',2,5,10),
(40,'2017-01-31',3,8,10),
(40,'2017-01-31',3,9,10),
(40,'2017-01-31',3,10,10),
(40,'2017-01-31',3,11,10),
(40,'2017-01-31',3,12,10),
(40,'2017-01-31',3,13,10),
(40,'2017-01-31',3,14,10),
(40,'2017-01-31',3,15,10),
(40,'2017-01-31',3,16,10),
(90,'2017-01-31',4,17,5),
(90,'2017-01-31',4,18,5),
(90,'2017-01-31',4,19,5),
(90,'2017-01-31',4,20,5),
(90,'2017-01-31',4,21,5),
(90,'2017-01-31',4,22,5),
(16,'2017-01-31',5,23,10),
(16,'2017-01-31',5,24,10),
(16,'2017-01-31',5,25,10),
(16,'2017-01-31',5,26,10),
(13,'2017-01-31',7,44,100),
(13,'2017-01-31',7,45,100),
(13,'2017-01-31',7,46,100),
(13,'2017-01-31',7,47,100),
(13,'2017-01-31',7,48,100),
(76,'2017-02-28',9,34,4),
(76,'2017-02-28',9,35,4),
(76,'2017-02-28',9,36,1),
(196,'2017-02-28',4,17,5),
(196,'2017-02-28',4,18,5),
(196,'2017-02-28',4,19,5),
(196,'2017-02-28',4,20,5),
(196,'2017-02-28',4,21,5),
(196,'2017-02-28',4,22,5),
(176,'2017-03-31',5,27,10),
(176,'2017-03-31',5,28,10),
(176,'2017-03-31',6,42,4),
(176,'2017-03-31',6,43,2),
(189,'2017-03-31',10,53,5),
(189,'2017-03-31',10,54,5),
(189,'2017-03-31',10,55,5),
(189,'2017-03-31',10,56,5),
(189,'2017-03-31',10,61,5),
(189,'2017-03-31',10,62,5),
(189,'2017-03-31',10,63,5),
(189,'2017-03-31',10,64,5),
(189,'2017-03-31',10,65,5),
(240,'2017-03-31',9,35,8),
(301,'2017-03-31',2,1,5),
(301,'2017-03-31',2,2,5),
(301,'2017-03-31',2,3,5),
(174,'2017-04-30',1,49,8),
(174,'2017-04-30',1,50,3),
(441,'2017-04-30',10,57,5),
(441,'2017-04-30',10,58,5),
(441,'2017-04-30',10,59,5),
(441,'2017-04-30',10,60,5),
(441,'2017-04-30',10,66,5),
(441,'2017-04-30',10,67,5),
(441,'2017-04-30',10,68,5),
(441,'2017-04-30',10,69,5),
(441,'2017-04-30',10,70,5),
(400,'2017-04-30',2,6,10),
(211,'2017-04-30',7,44,100),
(211,'2017-04-30',7,45,100),
(211,'2017-04-30',7,46,100),
(211,'2017-04-30',7,47,100),
(211,'2017-04-30',7,48,100),
(1105,'2017-05-31',6,41,3),
(1105,'2017-05-31',6,42,8),
(1105,'2017-05-31',6,43,4),
(211,'2017-05-31',1,51,8),
(211,'2017-05-31',1,52,7);


INSERT INTO `notavendita` (`DataNota`,`Cliente`)
VALUES ('2017-02-01',2),
('2017-02-01',8),
('2017-02-01',7),
('2017-02-02',2),
('2017-02-18',16),
('2017-02-22',3),
('2017-02-25',NULL),
('2017-03-02',11),
('2017-03-10',4),
('2017-03-11',10),
('2017-03-11',NULL),
('2017-03-23',13),
('2017-04-06',1),
('2017-04-10',2),
('2017-04-29',9),
('2017-05-01',15),
('2017-05-02',12),
('2017-05-15',5),
('2017-05-24',NULL),
('2017-06-01',6),
('2017-06-01',14),
('2017-06-01',1),
('2017-06-10',4);

INSERT INTO `notavendita` (`DataNota`,`Cliente`)
VALUES ('2017-06-10',2),
('2017-06-11',2),
('2017-06-12',2),
('2017-06-13',2),
('2017-06-14',2),
('2017-06-15',2),
('2017-06-16',2);



INSERT INTO `vendita` (`NotaVendita`,`DataNota`,`Articolo`,`Quantita`)
VALUES (1,'2017-02-01',1,1),
(1,'2017-02-01',2,1),
(1,'2017-02-01',8,1),
(2,'2017-02-01',44,25),
(3,'2017-02-01',45,20),
(4,'2017-02-02',3,1),
(4,'2017-02-02',4,1),
(5,'2017-02-18',17,1),
(5,'2017-02-18',18,1),
(5,'2017-02-18',19,1),
(6,'2017-02-22',8,1),
(6,'2017-02-22',9,1),
(6,'2017-02-22',10,1),
(6,'2017-02-22',11,1),
(6,'2017-02-22',15,1),
(7,'2017-02-25',3,1),
(7,'2017-02-25',4,1),
(7,'2017-02-25',5,1),
(8,'2017-03-02',34,1),
(8,'2017-03-02',35,1),
(8,'2017-03-02',46,30),
(8,'2017-03-02',48,20),
(8,'2017-03-02',36,1),
(9,'2017-03-10',17,1),
(9,'2017-03-10',18,1),
(9,'2017-03-10',19,1),
(9,'2017-03-10',20,1),
(9,'2017-03-10',21,1),
(9,'2017-03-10',22,1),
(10,'2017-03-11',3,8),
(10,'2017-03-11',24,10),
(10,'2017-03-11',2,9),
(10,'2017-03-11',17,3),
(11,'2017-03-11',18,3),
(11,'2017-03-11',19,3),
(11,'2017-03-11',20,4),
(11,'2017-03-11',21,4),
(11,'2017-03-11',22,4),
(12,'2017-03-23',1,1),
(12,'2017-03-23',34,1),
(12,'2017-03-23',35,1),
(12,'2017-03-23',44,40),
(13,'2017-04-06',53,1),
(13,'2017-04-06',54,1),
(13,'2017-04-06',55,1),
(13,'2017-04-06',56,1),
(13,'2017-04-06',42,3),
(13,'2017-04-06',8,6),
(13,'2017-04-06',9,6),
(13,'2017-04-06',15,3),
(13,'2017-04-06',14,4),
(13,'2017-04-06',1,1),
(13,'2017-04-06',2,1),
(13,'2017-04-06',3,1),
(14,'2017-04-10',61,1),
(14,'2017-04-10',62,1),
(14,'2017-04-10',63,1),
(14,'2017-04-10',64,1),
(14,'2017-04-10',65,1),
(14,'2017-04-10',43,2),
(14,'2017-04-10',34,1),
(14,'2017-04-10',35,1),
(14,'2017-04-10',47,50),
(15,'2017-04-29',42,1),
(15,'2017-04-29',47,30),
(15,'2017-04-29',48,30),
(15,'2017-04-29',45,25),
(16,'2017-05-01',57,1),
(16,'2017-05-01',58,1),
(16,'2017-05-01',59,1),
(16,'2017-05-01',60,1),
(16,'2017-05-01',49,4),
(16,'2017-05-01',50,2),
(16,'2017-05-01',44,20),
(16,'2017-05-01',45,20),
(16,'2017-05-01',46,20),
(16,'2017-05-01',47,20),
(16,'2017-05-01',48,20),
(17,'2017-05-02',6,1),
(18,'2017-05-15',66,1),
(18,'2017-05-15',67,1),
(18,'2017-05-15',68,1),
(18,'2017-05-15',69,1),
(18,'2017-05-15',70,1),
(18,'2017-05-15',35,1),
(19,'2017-05-24',44,30),
(19,'2017-05-24',45,30),
(19,'2017-05-24',46,30),
(19,'2017-05-24',47,30),
(19,'2017-05-24',48,30),
(20,'2017-06-01',41,1),
(21,'2017-06-01',41,1),
(22,'2017-06-01',41,1),
(23,'2017-06-10',51,4),
(23,'2017-06-10',52,4);

INSERT INTO `vendita` (`NotaVendita`,`DataNota`,`Articolo`,`Quantita`)
VALUES (24,'2017-06-10',12,1),
(25,'2017-06-11',13,1),
(26,'2017-06-12',16,1),
(27,'2017-06-13',23,1),
(28,'2017-06-14',25,1),
(29,'2017-06-15',26,1),
(30,'2017-06-16',27,1);

INSERT INTO `ordine` (`NumeroOrdine`,`DataOrdine`,`StatoOrdine`,`Cliente`)
VALUES (1,'2017-02-20',1,15),
(2,'2017-03-26',1,1),
(3,'2017-04-29',1,2),
(4,'2017-06-15',0,2);


INSERT INTO `ordinearticolo` (`Ordine`,`DataOrdine`,`Articolo`,`Quantita`)
VALUES (1,'2017-02-20',36,1),
(1,'2017-02-20',2,1),
(2,'2017-03-26',1,1),
(2,'2017-03-26',2,1),
(2,'2017-03-26',3,1),
(3,'2017-04-29',6,1),
(4,'2017-06-15',41,1);
