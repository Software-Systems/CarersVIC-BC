tableextension 50122 "Purch Inv Header Ext" extends "Purch. Inv. Header"
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