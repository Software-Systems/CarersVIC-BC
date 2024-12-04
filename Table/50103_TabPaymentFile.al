table 50103 "Payment File Data"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;

        }
        field(2; "Vendor Bank Branch"; code[20])
        {
            Caption = 'Vendor Bank Branch';
        }
        field(3; "Vendor Bank Account"; Text[50])
        {
            Caption = 'Vendor Bank Account';
        }
        field(4; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(5; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
        }
        field(6; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(7; "Payment File Text"; Text[500])
        {
            Caption = 'Payment File Text';
        }
        field(8; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(9; "Comp Bank Account Name"; Text[100])
        {
            Caption = 'Comp Bank Account Name';
        }
        field(10; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;

        }
    }


}