tableextension 50023 "Vendor Ext" extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Invoice Recipient Email"; Text[100])
        {
            Caption = 'Invoice Recipient Email';
        }
        field(50101; "Remittance Recipient Email"; Text[100])
        {
            Caption = 'Remittance Recipient Email';
            trigger OnValidate()
            begin
                if (rec."Remittance Recipient Email" <> xRec."Remittance Recipient Email") and (Rec."Vendor Created" = false) then begin
                    SendEmailforVendorDetailChange(5);
                end;
            end;
        }
        field(50102; "Vendor Created"; Boolean)
        {
            Caption = 'Vendor Created';
        }
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                if (rec.Name <> xRec.Name) and (Rec."Vendor Created" = false) then begin
                    SendEmailforVendorDetailChange(1);
                end;
            end;
        }
        modify("EFT Bank Account No.")
        {
            trigger OnAfterValidate()
            begin
                if (rec."EFT Bank Account No." <> xRec."EFT Bank Account No.") and (Rec."Vendor Created" = false) then begin
                    SendEmailforVendorDetailChange(2);
                end;
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                if (rec."No." <> xRec."No.") and (Rec."Vendor Created" = false) then begin
                    SendEmailforVendorDetailChange(3);
                end;
            end;
        }
        modify("E-Mail")
        {
            trigger OnAfterValidate()
            begin
                if (rec."E-mail" <> xRec."E-Mail") and (Rec."Vendor Created" = false) then begin
                    SendEmailforVendorDetailChange(6);
                end;
            end;
        }
        modify("Phone No.")
        {
            trigger OnAfterValidate()
            begin
                if (rec."Phone No." <> xRec."Phone No.") and (Rec."Vendor Created" = false) then begin
                    SendEmailforVendorDetailChange(7);
                end;
            end;
        }
        modify("Mobile Phone No.")
        {
            trigger OnAfterValidate()
            begin
                if (rec."Mobile Phone No." <> xRec."Mobile Phone No.") and (Rec."Vendor Created" = false) then begin
                    SendEmailforVendorDetailChange(8);
                end;
            end;
        }
        modify(Address)
        {
            trigger OnAfterValidate()
            begin
                if (rec."Address" <> xRec."Address") and (Rec."Vendor Created" = false) then begin
                    SendEmailforVendorDetailChange(9);
                end;
            end;
        }
        modify("Address 2")
        {
            trigger OnAfterValidate()
            begin
                if (rec."Address 2" <> xRec."Address 2") and (Rec."Vendor Created" = false) then begin
                    SendEmailforVendorDetailChange(10);
                end;
            end;
        }
        modify("Country/Region Code")
        {
            trigger OnAfterValidate()
            begin
                if (rec."Country/Region Code" <> xRec."Country/Region Code") and (Rec."Vendor Created" = false) then begin
                    SendEmailforVendorDetailChange(11);
                end;
            end;
        }
        modify(City)
        {
            trigger OnAfterValidate()
            begin
                if (rec.City <> xRec.City) and (Rec."Vendor Created" = false) then begin
                    SendEmailforVendorDetailChange(12);
                end;
            end;
        }
        modify(County)
        {
            trigger OnAfterValidate()
            begin
                if (rec."County" <> xRec."County") and (Rec."Vendor Created" = false) then begin
                    SendEmailforVendorDetailChange(13);
                end;
            end;
        }
        modify("Post Code")
        {
            trigger OnAfterValidate()
            begin
                if (rec."Post Code" <> xRec."Post Code") and (Rec."Vendor Created" = false) then begin
                    SendEmailforVendorDetailChange(14);
                end;
            end;
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

    procedure SendEmailforVendorDetailChange(ChangeType: Integer)
    var
        UserRec: Record User;
        UserSetup: Record "User Setup";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        EmailList: Text[250];
        FullName: Text;
    begin

        // If ChangeType = 1 --> Name Change
        // If ChangeType = 2 --> Bank Account Change
        // If ChangeType = 3 --> No. Change
        // If ChangeType = 4 --> new vendor is added
        // If ChangeType = 5 --> Remittance Recipient Email Changes
        // If ChangeType = 6 --> Email changes
        // If ChangeType = 7 --> Phone No. Change
        // If ChangeType = 8 --> Mobile Phone Change
        // If ChangeType = 9 --> Address Change
        // If ChangeType = 10 --> Address2 Change
        // If ChangeType = 11 --> County/Region Change
        // If ChangeType = 12 --> City Change
        // If ChangeType = 13 --> Country Change
        // If ChangeType = 14 --> PostCode Change


        if UserRec.Get(UserSecurityId()) then begin
            FullName := UserRec."Full Name";
        end else begin
            FullName := 'Unknown User'; // Fallback if user not found
        end;


        UserSetup.Reset();
        UserSetup.SetRange("Send email for Vendor changes", true);
        if UserSetup.FindSet() then
            repeat
                if EmailList <> '' then
                    EmailList := InsStr(EmailList + ';', UserSetup."E-Mail", 999)
                else
                    EmailList := UserSetup."E-Mail";
            Until UserSetup.Next() = 0;

        if ChangeType = 1 then begin
            EmailMessage.Create(EmailList, 'Vendor Details Changed : ' + Rec."No." + '', 'Please Note that the following updates has been made by: ' + FullName + ' <br> ' + 'Name was updated from: ' + xRec."Name" + ' To: ' + Rec."Name" + ' <br> ', true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
        if ChangeType = 2 then begin
            EmailMessage.Create(EmailList, 'Vendor Details Changed : ' + Rec."No." + '', 'Please Note that the following updates has been made by: ' + FullName + ' <br> ' + 'EFT Bank Account No. was updated from:' + xRec."EFT Bank Account No." + ' To: ' + Rec."EFT Bank Account No." + ' <br> ', true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
        if ChangeType = 3 then begin
            EmailMessage.Create(EmailList, 'Vendor Details Changed : ' + Rec."No." + '', 'Please Note that the following updates has been made by: ' + FullName + ' <br> ' + 'Vendor No. was updated from:' + xRec."No." + ' To: ' + Rec."No." + ' <br> ', true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
        if ChangeType = 4 then begin
            EmailMessage.Create(EmailList, 'New Vendor Created: ' + Rec."No." + '', 'A new Vendor was  created by: ' + FullName + ' Vendor No: ' + Rec."No." + ' <br> ', true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
        if ChangeType = 5 then begin
            EmailMessage.Create(EmailList, 'Vendor Details Changed : ' + Rec."No." + '', 'Please Note that the following updates has been made by: ' + FullName + ' <br> ' + 'Remittance Recipient Email was updated from:' + xRec."Remittance Recipient Email" + ' To: ' + Rec."Remittance Recipient Email" + ' <br> ', true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
        if ChangeType = 6 then begin
            EmailMessage.Create(EmailList, 'Vendor Details Changed : ' + Rec."No." + '', 'Please Note that the following updates has been made by: ' + FullName + ' <br> ' + 'Vendor Email was updated from: ' + xRec."E-Mail" + ' To: ' + Rec."E-mail" + ' <br> ', true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
        if ChangeType = 7 then begin
            EmailMessage.Create(EmailList, 'Vendor Details Changed : ' + Rec."No." + '', 'Please Note that the following updates has been made by: ' + FullName + ' <br>  ' + 'Phone No. was updated from: ' + xRec."Phone No." + ' To: ' + Rec."Phone No." + ' <br> ', true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
        if ChangeType = 8 then begin
            EmailMessage.Create(EmailList, 'Vendor Details Changed : ' + Rec."No." + '', 'Please Note that the following updates has been made by: ' + FullName + ' <br> ' + 'Mobile Phone No. was updated from:  ' + xRec."Mobile Phone No." + ' To: ' + Rec."Mobile Phone No." + ' <br> ', true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
        if ChangeType = 9 then begin
            EmailMessage.Create(EmailList, 'Vendor Details Changed : ' + Rec."No." + '', 'Please Note that the following updates has been made by: ' + FullName + ' <br> ' + 'Vendor Address was updated from: ' + xRec.Address + ' To: ' + Rec."Address" + ' <br> ', true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
        if ChangeType = 10 then begin
            EmailMessage.Create(EmailList, 'Vendor Details Changed : ' + Rec."No." + '', 'Please Note that the following updates has been made by: ' + FullName + ' <br> ' + 'Vendor Address 2 was updated from: ' + xRec."Address 2" + ' To: ' + Rec."Address 2" + ' <br> ', true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
        if ChangeType = 11 then begin
            EmailMessage.Create(EmailList, 'Vendor Details Changed : ' + Rec."No." + '', 'Please Note that the following updates has been made by: ' + FullName + ' <br> ' + 'Country/Region Code was updated from: ' + xRec."Country/Region Code" + ' To: ' + Rec."Country/Region Code" + ' <br> ', true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
        if ChangeType = 12 then begin
            EmailMessage.Create(EmailList, 'Vendor Details Changed : ' + Rec."No." + '', 'Please Note that the following updates has been made by: ' + FullName + ' <br> ' + xRec."City" + ' To: ' + Rec.City + ' <br> ', true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
        if ChangeType = 13 then begin
            EmailMessage.Create(EmailList, 'Vendor Details Changed : ' + Rec."No." + '', 'Please Note that the following updates has been made by: ' + FullName + ' <br> ' + 'County was updated from: ' + xRec."County" + ' To: ' + Rec.County + ' <br> ', true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
        if ChangeType = 14 then begin
            EmailMessage.Create(EmailList, 'Vendor Details Changed : ' + Rec."No." + '', 'Please Note that the following updates has been made by: ' + FullName + ' <br> ' + 'Post Code was updated from: ' + xRec."Post Code" + ' To: ' + Rec."Post Code" + ' <br> ', true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
    end;

    var
        myInt: Integer;

    trigger OnAfterInsert()
    begin
        // if rec."No." <> xRec."No." then begin
        "Vendor Created" := true;
        SendEmailforVendorDetailChange(4);
    end;

}