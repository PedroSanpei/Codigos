SELECT
	oeh.order_number,
	oel.ordered_item,
	oel.ordered_quantity,
	oel.unit_selling_price
--	max(oel.line_number) as ln
--	oel.*
FROM
	apps.oe_order_lines_all oel
inner join
	apps.oe_order_headers_all oeh on
		oeh.org_id = oel.org_id
	and oeh.header_id = oel.header_id
where
	oeh.org_id = 145
and oeh.ship_from_org_id = 151
--and oeh.order_number = '18330';
and	trunc(oeh.creation_date) > trunc(add_months(sysdate,-4))
and ((length((oel.unit_selling_price) - trunc(oel.unit_selling_price)) - 1) > 2
--and mod(oel.ordered_quantity,2)!= 0)
and 1 < all(select a.ordered_quantity from apps.oe_order_lines_all a where a.org_id = oeh.org_id and a.header_id = oeh.header_id))

group by
	oeh.order_number,
	oel.ordered_item,
	oel.ordered_quantity,
	oel.unit_selling_price
having max(oel.line_number) > 3
order by case when mod(oel.ordered_quantity, 2) != 0 then 1 else 2 end, 1;	EBS_HML - APPS	1623696775010	SQL	1	0.369