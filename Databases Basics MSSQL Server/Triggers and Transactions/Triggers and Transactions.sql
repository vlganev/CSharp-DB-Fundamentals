-- Problem 1.	Create Table Logs
CREATE TABLE Logs
(
	LogID INT PRIMARY KEY IDENTITY,
	AccountID INT FOREIGN KEY REFERENCES Accounts(Id),
	OldSum MONEY NOT NULL,
	NewSum MONEY NOT NULL
)


CREATE TRIGGER tr_AccountsUpdate 
			ON Accounts FOR UPDATE
            AS
   INSERT INTO Logs
        SELECT inserted.Id, 
 		       deleted.Balance, 
 			   inserted.Balance 
 	      FROM inserted
          JOIN deleted
            ON inserted.Id = deleted.Id

-- Problem 2.	Create Table Emails
CREATE TABLE NotificationEmails
(
	Id INT PRIMARY KEY IDENTITY,
	Recipient INT FOREIGN KEY REFERENCES Accounts(Id),
	Subject VARCHAR(100),
	Body VARCHAR(200)
)

CREATE TRIGGER tr_LogsInsert 
            ON Logs FOR INSERT
            AS
     	INSERT INTO NotificationEmails
     	SELECT AccountId,  
     		'Balance change for account: ' + CAST(AccountID AS varchar(20)),
     		'On ' + CONVERT(VARCHAR(50), GETDATE(), 100) + ' your balance was changed from ' + 
     		CAST(OldSum AS varchar(20)) + ' to ' + CAST(NewSum AS varchar(20))
     	  FROM inserted

-- Problem 3.	Deposit Money
CREATE PROCEDURE usp_DepositMoney (@AccountID INT, @MoneyAmount DECIMAL(15, 4)) 
AS
IF (@MoneyAmount >= 0)
BEGIN
	UPDATE Accounts
	   SET Balance += @MoneyAmount
	 WHERE Id = @AccountId
END

-- Problem 4.	Withdraw Money

CREATE PROC usp_DepositMoney (@AccountId INT, @MoneyAmount MONEY) 
    AS
 BEGIN
	BEGIN TRAN
		IF (@MoneyAmount > 0)
		BEGIN
			UPDATE Accounts
			SET Balance += @MoneyAmount
			WHERE Id = @AccountId

			IF @@ROWCOUNT != 1
			BEGIN
				ROLLBACK
				RAISERROR('Invalid account!', 16, 1)
				RETURN
			END
		END
	COMMIT
   END 


-- Problem 5.	Money Transfer
CREATE PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount money) AS
BEGIN 
	BEGIN TRAN
		IF(@Amount > 0)
		BEGIN
			EXEC usp_WithdrawMoney @SenderId, @Amount
			EXEC usp_DepositMoney @ReceiverId, @Amount
		END
	COMMIT
END


