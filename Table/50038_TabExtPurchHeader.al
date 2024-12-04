tableextension 50038 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Imported record"; Boolean)
        {
            Caption = 'Imported record';
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