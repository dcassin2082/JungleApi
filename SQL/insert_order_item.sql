USE [JungleDB]
GO
/****** Object:  StoredProcedure [dbo].[insert_order_item]    Script Date: 9/5/2020 1:57:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[insert_order_item] @orderId   INT, 
                                          @productId INT, 
                                          @itemCount INT 
AS 
  BEGIN 
      SET nocount ON; 

      DECLARE @lineTotal DECIMAL(18, 2) 
      DECLARE @description NVARCHAR(max) 
      DECLARE @sku NVARCHAR(50) 
      DECLARE @largePhoto VARBINARY(max) 
      DECLARE @thumbnailPhoto VARBINARY(max) 
      DECLARE @thumbnailPhotoFileName NVARCHAR(50) 
      DECLARE @largePhotoFileName NVARCHAR(50) 

      SET @largePhotoFileName = (SELECT largephotofilename 
                                 FROM   product 
                                 WHERE  productid = @productId) 
      SET @largePhoto = (SELECT largephoto 
                         FROM   product 
                         WHERE  productid = @productId) 
      SET @thumbnailPhotoFileName = (SELECT thumbnailphotofilename 
                                     FROM   product 
                                     WHERE  productid = @productId) 
      SET @thumbnailPhoto = (SELECT thumbnailphoto 
                             FROM   product 
                             WHERE  productid = @productId) 
      SET @sku = (SELECT sku 
                  FROM   product 
                  WHERE  productid = @productId) 
      SET @lineTotal = (SELECT price 
                        FROM   product 
                        WHERE  productid = @productId) * @itemCount 
      SET @description = (SELECT description 
                          FROM   product 
                          WHERE  productid = @productId) 

      INSERT orderitem 
             (orderid, 
              productid, 
              linetotal, 
              description, 
              sku, 
              itemcount,
			  thumbnailphoto,
			  largephoto,
			  thumbnailphotofilename,
			  largephotofilename) 
      VALUES(@orderId, 
             @productId, 
             @lineTotal, 
             @description, 
             @sku, 
             @itemCount,
			 @thumbnailPhoto,
			 @largePhoto,
			 @thumbnailPhotoFileName,
			 @largePhotoFileName) 
		update customerorder set OrderSubTotal=OrderSubTotal + @lineTotal
  END 

