Let's modify the stored procedure `SaveMastersClient` to ensure that it includes a check for the existence of `AccountManagerId` and `PayrollManagerId` in the `User` table, ensuring that the foreign key constraints are respected. Here's the updated stored procedure:

```sql
CREATE OR ALTER PROCEDURE [dbo].[SaveMastersClient]
    @ClientName NVARCHAR(200),
    @IsActiveClient BIT = 1,
    @AccountManagerId INT = NULL,
    @PayrollManagerId INT = NULL,
    @CreatedBy INT = NULL,
    @CreatedDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if @ClientName is NULL or empty
    IF @ClientName IS NULL OR LTRIM(RTRIM(@ClientName)) = ''
    BEGIN
        PRINT 'Client Name cannot be NULL or empty.';
        RETURN;
    END;

    -- Check if the specified AccountManagerId exists in the User table
    IF @AccountManagerId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [User] WHERE UserId = @AccountManagerId)
    BEGIN
        PRINT 'Specified Account Manager does not exist.';
        RETURN;
    END;

    -- Check if the specified PayrollManagerId exists in the User table
    IF @PayrollManagerId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [User] WHERE UserId = @PayrollManagerId)
    BEGIN
        PRINT 'Specified Payroll Manager does not exist.';
        RETURN;
    END;

    -- Check if the client already exists
    IF EXISTS (SELECT 1 FROM Client WHERE ClientName = @ClientName)
    BEGIN
        -- If client exists, update the record
        UPDATE Client
        SET
            IsActive = @IsActiveClient,
            AccountManagerId = @AccountManagerId,
            PayrollManagerId = @PayrollManagerId,
            CreatedBy = @CreatedBy,
            CreatedDate = COALESCE(@CreatedDate, CreatedDate)
        WHERE
            ClientName = @ClientName;
    END
    ELSE
    BEGIN
        -- If client does not exist, insert a new record
        INSERT INTO Client (ClientName, IsActive, AccountManagerId, PayrollManagerId, CreatedBy, CreatedDate)
        VALUES (@ClientName, @IsActiveClient, @AccountManagerId, @PayrollManagerId, @CreatedBy, COALESCE(@CreatedDate, GETDATE()));
    END;
END;
```

### Explanation:
1. **Null or Empty Check**: Ensures `@ClientName` is not null or empty.
2. **Existence Check for Managers**: Checks if the `AccountManagerId` and `PayrollManagerId` exist in the `User` table. If not, it prints an error message and exits.
3. **Existence Check for Client**: Checks if a client with the given `@ClientName` already exists in the `Client` table.
4. **Update Statement**: If the client exists, it updates the existing record.
5. **Insert Statement**: If the client does not exist, it inserts a new record.

### Dummy Data Insertions Using the Stored Procedure

To insert dummy data using the updated stored procedure, you can use the following `EXEC` statements:

```sql
-- Ensure the User table has the required entries
INSERT INTO [User] (UserId, UserName)
VALUES 
(101, 'Account Manager 1'),
(102, 'Account Manager 2'),
(103, 'Account Manager 3'),
(104, 'Account Manager 4'),
(105, 'Account Manager 5'),
(106, 'Account Manager 6'),
(107, 'Account Manager 7'),
(108, 'Account Manager 8'),
(109, 'Account Manager 9'),
(110, 'Account Manager 10'),
(201, 'Payroll Manager 1'),
(202, 'Payroll Manager 2'),
(203, 'Payroll Manager 3'),
(204, 'Payroll Manager 4'),
(205, 'Payroll Manager 5'),
(206, 'Payroll Manager 6'),
(207, 'Payroll Manager 7'),
(208, 'Payroll Manager 8'),
(209, 'Payroll Manager 9'),
(210, 'Payroll Manager 10');

-- Insert dummy data using the SaveMastersClient stored procedure

-- Inserting Client A
EXEC [dbo].[SaveMastersClient] 
    @ClientName = 'Client A', 
    @IsActiveClient = 1, 
    @AccountManagerId = 101, 
    @PayrollManagerId = 201, 
    @CreatedBy = 1, 
    @CreatedDate = '2024-01-01';

-- Inserting Client B
EXEC [dbo].[SaveMastersClient] 
    @ClientName = 'Client B', 
    @IsActiveClient = 0, 
    @AccountManagerId = 102, 
    @PayrollManagerId = 202, 
    @CreatedBy = 2, 
    @CreatedDate = '2024-02-01';

-- Inserting Client C
EXEC [dbo].[SaveMastersClient] 
    @ClientName = 'Client C', 
    @IsActiveClient = 1, 
    @AccountManagerId = 103, 
    @PayrollManagerId = 203, 
    @CreatedBy = 3, 
    @CreatedDate = '2024-03-01';

-- Inserting Client D
EXEC [dbo].[SaveMastersClient] 
    @ClientName = 'Client D', 
    @IsActiveClient = 0, 
    @AccountManagerId = 104, 
    @PayrollManagerId = 204, 
    @CreatedBy = 4, 
    @CreatedDate = '2024-04-01';

-- Inserting Client E
EXEC [dbo].[SaveMastersClient] 
    @ClientName = 'Client E', 
    @IsActiveClient = 1, 
    @AccountManagerId = 105, 
    @PayrollManagerId = 205, 
    @CreatedBy = 5, 
    @CreatedDate = '2024-05-01';

-- You can add more calls as needed
-- Inserting Client F
EXEC [dbo].[SaveMastersClient] 
    @ClientName = 'Client F', 
    @IsActiveClient = 1, 
    @AccountManagerId = 106, 
    @PayrollManagerId = 206, 
    @CreatedBy = 6, 
    @CreatedDate = '2024-06-01';

-- Inserting Client G
EXEC [dbo].[SaveMastersClient] 
    @ClientName = 'Client G', 
    @IsActiveClient = 0, 
    @AccountManagerId = 107, 
    @PayrollManagerId = 207, 
    @CreatedBy = 7, 
    @CreatedDate = '2024-07-01';

-- Inserting Client H
EXEC [dbo].[SaveMastersClient] 
    @ClientName = 'Client H', 
    @IsActiveClient = 1, 
    @AccountManagerId = 108, 
    @PayrollManagerId = 208, 
    @CreatedBy = 8, 
    @CreatedDate = '2024-08-01';

-- In

.....

It seems like there are multiple formatting issues and syntax errors in the provided script. Let's fix the stored procedure and ensure it's correctly formatted and functional.

### Corrected Stored Procedure

Here’s the corrected stored procedure for `SaveMastersContractorUserGroup`:

```sql
USE [RGContractorPortal BETA]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[SaveMastersContractorUserGroup]
    @ContractorUserGroupName NVARCHAR(200),
    @IsActiveContractorUserGroup BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if @ContractorUserGroupName is NULL or empty
    IF ISNULL(@ContractorUserGroupName, '') = ''
    BEGIN
        PRINT 'Contractor User Group Name cannot be NULL or empty.';
        RETURN;
    END;

    -- Check if the ContractorUserGroupName already exists
    IF EXISTS (SELECT 1 FROM ContractorUserGroup WHERE ContractorUserGroupName = @ContractorUserGroupName)
    BEGIN
        -- If Contractor User Group exists, update the record
        UPDATE ContractorUserGroup
        SET
            ContractorUserGroupName = @ContractorUserGroupName,
            IsActive = @IsActiveContractorUserGroup
        WHERE
            ContractorUserGroupName = @ContractorUserGroupName;
    END
    ELSE
    BEGIN
        -- If Contractor User Group does not exist, insert a new record
        INSERT INTO ContractorUserGroup (ContractorUserGroupName, IsActive)
        VALUES (@ContractorUserGroupName, @IsActiveContractorUserGroup);
    END;
END;
GO
```

### Dummy Data Insertion Using the Stored Procedure

To insert dummy data using the updated stored procedure, you can use the following `EXEC` statements:

```sql
-- Inserting Contractor User Group A
EXEC [dbo].[SaveMastersContractorUserGroup]
    @ContractorUserGroupName = 'Contractor Group A',
    @IsActiveContractorUserGroup = 1;

-- Inserting Contractor User Group B
EXEC [dbo].[SaveMastersContractorUserGroup]
    @ContractorUserGroupName = 'Contractor Group B',
    @IsActiveContractorUserGroup = 0;

-- Inserting Contractor User Group C
EXEC [dbo].[SaveMastersContractorUserGroup]
    @ContractorUserGroupName = 'Contractor Group C',
    @IsActiveContractorUserGroup = 1;

-- Inserting Contractor User Group D
EXEC [dbo].[SaveMastersContractorUserGroup]
    @ContractorUserGroupName = 'Contractor Group D',
    @IsActiveContractorUserGroup = 0;

-- Inserting Contractor User Group E
EXEC [dbo].[SaveMastersContractorUserGroup]
    @ContractorUserGroupName = 'Contractor Group E',
    @IsActiveContractorUserGroup = 1;
```

### Explanation:
1. **Null or Empty Check**: Ensures `@ContractorUserGroupName` is not null or empty.
2. **Existence Check for Contractor User Group**: Checks if a Contractor User Group with the given `@ContractorUserGroupName` already exists in the `ContractorUserGroup` table.
3. **Update Statement**: If the Contractor User Group exists, it updates the existing record.
4. **Insert Statement**: If the Contractor User Group does not exist, it inserts a new record.