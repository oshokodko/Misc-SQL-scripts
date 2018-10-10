DECLARE @LinkedServer SYSNAME = '[.\SQL2017]'
DECLARE @CertificateName NVARCHAR(1024) = 'TestCertificate'
DECLARE @Password NVARCHAR(1024) = N'SomeOther!' --better use NewID()


DECLARE @sqlGetCertificateKeys NVARCHAR(MAX) = 
'EXEC (''SELECT CERTENCODED(CERT_ID(N''''{CertificateName}'''')),
	     CERTPRIVATEKEY(	CERT_ID(N''''{CertificateName}''''), N''''{Password}'''') ''
	) AT {LinkedServer}'
SET @sqlGetCertificateKeys = REPLACE(@sqlGetCertificateKeys,N'{CertificateName}', @CertificateName)
SET @sqlGetCertificateKeys = REPLACE(@sqlGetCertificateKeys,N'{Password}', @Password)
SET @sqlGetCertificateKeys = REPLACE(@sqlGetCertificateKeys,N'{LinkedServer}', @LinkedServer)

DROP TABLE IF EXISTS #LinkedServerKeys;
CREATE TABLE #LinkedServerKeys (
    PublicKey VARBINARY(MAX) NOT NULL,
    PrivateKey VARBINARY(MAX) NOT NULL
);
INSERT INTO #LinkedServerKeys (PublicKey, PrivateKey)
EXEC (@sqlGetCertificateKeys)

DECLARE @PublicKey NVARCHAR(MAX),
	@PrivateKey NVARCHAR(MAX)

SELECT @PublicKey=  CONVERT(NVARCHAR(MAX), PublicKey, 1), 
@PrivateKey = CONVERT(NVARCHAR(MAX), PrivateKey, 1)
FROM #LinkedServerKeys;

DECLARE @sqlCreateCertificate NVARCHAR(MAX) 
SELECT @sqlCreateCertificate =
N'CREATE CERTIFICATE '+ @CertificateName +'
FROM BINARY = ' + @PublicKey +'
WITH PRIVATE KEY (BINARY = '+@PrivateKey+',
    DECRYPTION BY PASSWORD = '''+@Password+''');'
--print @sqlCreateCertificate

EXEC (@sqlCreateCertificate);

