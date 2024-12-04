tableextension 50112 "Sales Inv Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Imported record"; Boolean)
        {
            Caption = 'Imported record';
        }
        field(50101; "Invoice Delivery Method"; Enum "Invoice Delivery Method")
        {
            Caption = 'Invoice Delivery Method';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}