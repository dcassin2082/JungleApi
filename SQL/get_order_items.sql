USE [JungleDB]
GO
/****** Object:  StoredProcedure [dbo].[Get_order_items]    Script Date: 9/5/2020 1:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select co.CustomerID, oi.OrderItemID, oi.Description, oi.LineTotal,  oi.ProductID, oi.SKU 
from orderitem oi join customerorder co on
oi.OrderID = co.OrderID
where oi.OrderID=104
*/
ALTER PROCEDURE [dbo].[Get_order_items] 
	@orderId INT
AS 
  BEGIN 
      SET nocount ON; 

      SELECT DISTINCT co.CustomerID, 
                      co.OrderID, 
                      oi.OrderItemID, 
                      oi.Description, 
                      oi.LineTotal, 
					  p.Price,
                      oi.ProductID, 
                      oi.SKU,
					  oi.ItemCount,
					  oi.LargePhoto,
					  oi.ThumbnailPhoto,
					  oi.LargePhotoFIleName,
					  oi.ThumbnailPhotoFileName,
					  oi.DetailedDescription
      FROM   orderitem oi 
             JOIN customerorder co 
               ON co.orderid = oi.orderid 
			 join product p on oi.ProductID = p.ProductID
      WHERE  oi.OrderID = @orderId 
      
  END 

