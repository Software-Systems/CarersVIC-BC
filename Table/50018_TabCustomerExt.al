tableextension 50018 "Customer Ext" extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Invoice Recipient Email"; Text[100])
        {
            Caption = 'Invoice Recipient Email';
        }
        field(50101; "Invoice Delivery method"; Enum "Invoice Delivery Method")
        {
            Caption = 'Invoice Delivery method';
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