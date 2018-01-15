CREATE DATABASE MDTWarehouse;

SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO 

CREATE TABLE MDTWarehouse.dbo.Deployments(
        [Name] [nvarchar](max) NOT NULL,
        [PercentComplete] [int] NULL,
        [Warnings] [int] NULL,
        [Errors] [int] NULL,
        [DeploymentStatus] [nvarchar](50) NULL,
        [StartTime] [nvarchar](50) NULL,
        [EndTime] [nvarchar](50) NULL,
		[UniqueID] [nvarchar](50) NULL,
		[CurrentStep] [int] NULL,
		[TotalSteps] [int] NULL,
		[StepName] [nvarchar](50) NULL,
		[LastTime] [nvarchar](50) NULL,
		[VMHost] [nvarchar](50) NULL,
		[VMName] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO