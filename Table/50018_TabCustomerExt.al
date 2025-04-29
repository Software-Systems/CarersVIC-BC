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
}