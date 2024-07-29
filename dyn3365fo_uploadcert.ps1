
openssl pkcs12 -export -out vrscert.pfx -inkey CSD_VEGUSA_RENTAL_STORE_SA_DE_CV_VRS2310024P0_20231110_134100.key -in CSD_VEGUSA_RENTAL_STORE_SA_DE_CV_VRS2310024P0_20231110_134100.sdg

Connect-AzAccount
$pfxFilePath = 'VRSCERT.pfx'
$pwd = 'VRS12345'
$secretName = 'VRSCertificateSecret'
$keyVaultName = 'DYN365FOEINV'

$collection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$collection.Import($pfxFilePath, $pwd,[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
$pkcs12ContentType = [System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12
$clearBytes = $collection.Export($pkcs12ContentType)
$fileContentEncoded = [System.Convert]::ToBase64String($clearBytes)
$secret = ConvertTo-SecureString -String $fileContentEncoded -AsPlainText –Force
$secretContentType = 'application/x-pkcs12'

Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $secretName -SecretValue $Secret -ContentType $secretContentType