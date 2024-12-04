tableextension 50036 "sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50100; "Imported record"; Boolean)
        {
            Caption = 'Imported record';
        }
        field(50101; "Invoice Delivery Method"; Enum "Invoice Delivery Method")
        {
            Caption = 'Invoice Delivery Method';
        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
            begin
                if Customer.Get("Sell-to Customer No.") then begin
                    "Invoice Delivery Method" := Customer."Invoice Delivery method";
                end;
            end;
        }
    }


}