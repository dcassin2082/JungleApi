USE [JungleDB]
GO
/****** Object:  StoredProcedure [dbo].[Create_customer_order]    Script Date: 9/5/2020 1:58:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Create_customer_order] @customerId     INT, 
                                       @orderDate      DATE, 
                                       @shippingCharge DECIMAL(18, 2), 
                                       @createdBy      INT, 
                                       @carrier        NVARCHAR(50), 
                                       @productId      INT, 
                                       @quantity       INT 
AS 
  BEGIN 
      SET nocount ON; 

      DECLARE @lineTotal DECIMAL(18, 2) 
      DECLARE @subTotal DECIMAL(18, 2) 
      DECLARE @total DECIMAL(18, 2) 
      DECLARE @description NVARCHAR(max) 
      DECLARE @sku NVARCHAR(50) 
      DECLARE @tax DECIMAL(18, 2) 

      SET @sku = (SELECT sku 
                  FROM   product 
                  WHERE  productid = @productId) 
      SET @description = (SELECT description 
                          FROM   product 
                          WHERE  productid = @productId) 
      SET @lineTotal = (SELECT price 
                        FROM   product 
                        WHERE  productid = @productId) 
      SET @subTotal = @lineTotal * @quantity 
	  SET @tax = @subTotal * 0.08
      SET @total = @subTotal + @tax + @shippingCharge 

      INSERT customerorder 
             (customerid, 
              orderdate, 
              ordertotal, 
              ordersubtotal, 
              tax, 
              shippingcharge, 
              createddate, 
              shipped, 
              createdby, 
              carrier, 
              itemcount) 
      VALUES(@customerId, 
             @orderDate, 
             @total, 
             @subTotal, 
             @tax, 
             @shippingCharge, 
             @orderDate, 
             1, 
             @createdBy, 
             @carrier, 
             1) 

      INSERT orderitem 
             (orderid, 
              productid, 
              linetotal, 
              description, 
              sku) 
      VALUES(Scope_identity(), 
             @productId, 
             @lineTotal, 
             @description, 
             @sku) 
  END 

