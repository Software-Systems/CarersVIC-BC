tableextension 50288 "Vendor Bank Account Ext" extends "Vendor Bank Account"
{
    fields
    {
        // Add changes to table fields here
        modify(Code)
        {
            trigger OnAfterValidate()
            begin
                if (rec.Code <> xRec.Code) then begin
                    SendEmailforVendorBankDetailChange(1);
                end;
            end;
        }

        modify("Bank Account No.")
        {
            trigger OnAfterValidate()
            begin
                if (rec."Bank Account No." <> xRec."Bank Account No.") then begin
                    SendEmailforVendorBankDetailChange(2);

                end;
            end;
        }
        modify("Bank Branch No.")
        {
            trigger OnAfterValidate()
            begin
                if (rec."Bank Branch No." <> xRec."Bank Branch No.") then begin
                    SendEmailforVendorBankDetailChange(3);
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

    procedure SendEmailforVendorBankDetailChange(ChangeType: Integer)
    var
        UserRec: Record User;
        User: Record User;
        UserSetup: Record "User Setup";
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        EmailList: Text[250];
        EmailBody: Text;
        FullName: Text;

    begin
        if UserRec.Get(UserSecurityId()) then begin
            FullName := UserRec."Full Name";
        end else begin
            FullName := 'Unknown User'; // Fallback if user not found
        end;
        UserSetup.SetRange("Send email for Vendor changes", true);
        if UserSetup.FindSet() then
            repeat
                if EmailList <> '' then
                    EmailList := EmailList + ';' + UserSetup."E-Mail"
                else
                    EmailList := UserSetup."E-Mail";
            until UserSetup.Next() = 0;

        case ChangeType of
            1:
                EmailBody := 'Code was updated from: ' + xRec."Code" + ' To: ' + Rec."Code";
            2:
                EmailBody := 'Bank Account No. was updated from: ' + xRec."Bank Account No." + ' To: ' + Rec."Bank Account No.";
            3:
                EmailBody := 'Bank Branch No. was updated from: ' + xRec."Bank Branch No." + ' To: ' + Rec."Bank Branch No.";
        end;

        EmailMessage.Create(EmailList, 'Vendor Bank Details Changed: ' + Rec.Code, 'Please Note that the following updates has been made by: ' + FullName + ' <br> ' + EmailBody, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);


    end;












}