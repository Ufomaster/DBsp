CREATE USER [SpeklerUser]
  FOR LOGIN [SpeklerUser]
GO

GRANT IMPERSONATE ON USER :: [SpeklerUser] TO [QlikView]
GO

GRANT IMPERSONATE ON USER :: [SpeklerUser] TO [SyncCRM]
GO