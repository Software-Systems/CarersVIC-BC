pageextension 50026 "Vendor Card Ext" extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("E-Mail")
        {
            field("Remittance Recipient Email"; Rec."Remittance Recipient Email")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here

    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Vendor: Record Vendor;
    begin
        if Rec."Vendor Created" = true then
            Message('Vendor Created');

        Vendor.Reset();
        Vendor.SetRange("Vendor Created", true);
        if Vendor.Findset() then
            repeat
                Vendor."Vendor Created" := false;
                Vendor.Modify();
            until Vendor.Next() = 0;

    end;



    var
        myInt: Integer;
}