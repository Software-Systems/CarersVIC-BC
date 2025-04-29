codeunit 50106 "Carers VIC Send Receipt"
{
    var
        Customer: Record Customer;

    local procedure GetSendToEmail(ParCustomerNo: Code[20]) RetValue: Text
    var
        Customer: Record Customer;
    begin
        if Customer.Get(ParCustomerNo) then
            RetValue := Customer."Invoice Recipient Email";

        Exit(RetValue);
    end;

    local procedure GetAttachment(ParCustomerNo: Code[20]; ParEntryNoText: Text; var EmailMessage: Codeunit "Email Message")
    var
        AttachmentTempBlob: Codeunit "Temp Blob";
        CustLedgerEntryRecRef: RecordRef;
        AttachmentInstream: InStream;
        AttachmentOutStream: OutStream;
        ReportParamenters: Text;
        AttachmentFileNameLbl: Label 'Customer Payment Receipt - %1.pdf', Comment = '%1 Customer Payment Receipt.';
        CustPaymentReceipt: Report "Customer - Payment Receipt";
    begin
        AttachmentTempBlob.CreateOutStream(AttachmentOutStream);
        CustPaymentReceipt.SetPar(ParEntryNoText);
        CustPaymentReceipt.SaveAs('', ReportFormat::Pdf, AttachmentOutStream);
        AttachmentTempBlob.CreateInStream(AttachmentInstream);
        EmailMessage.AddAttachment(StrSubstNo(AttachmentFileNameLbl, ParCustomerNo), '', AttachmentInstream);
    end;


    procedure SendCustomerPaymentReceipt(ParCustomerNo: Code[20]; ParEntryNoText: Text)
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        SendToEmail: List of [Text];
        CCEmail: List of [Text];
        BCCEmail: List of [Text];

        SubjectText: Text;
        BodyText: Text;
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        if Customer.Get(ParCustomerNo) then begin
            if GetSendToEmail(Customer."No.") = '' then
                Error('Please fill up "Invoice Recipient Email" for Customer %1 - %2', Customer."No.", Customer.Name)
            else begin
                SendToEmail.Add(GetSendToEmail(Customer."No."));
                //CCEmail.Add(Salesperson."E-Mail");

                SubjectText := 'Payment Receipt : ' + Customer.Name;
                BodyText := BodyText + '<p style="color:black">';
                BodyText := BodyText + 'Dear ' + Customer.Name + ',';
                BodyText := BodyText + '<br><br>';
                BodyText := BodyText + 'Thank you for your payment.';
                BodyText := BodyText + '<br><br>';
                BodyText := BodyText + 'Please find attached for your receipt(s).';
                BodyText := BodyText + '<br><br>';
                BodyText := BodyText + 'If you have any questions regarding this receipt or your account, please feel free to contact us';
                BodyText := BodyText + '<br><br>';
                BodyText := BodyText + 'We truly appreciate your business and look forward to serving you again!';
                BodyText := BodyText + '<br><br>';
                BodyText := BodyText + 'Thank you';
                BodyText := BodyText + '<br><br>';
                BodyText := BodyText + '<b>Regards,';
                BodyText := BodyText + '<br>';
                BodyText := BodyText + CompanyName;
                BodyText := BodyText + '</b>';

                EmailMessage.Create(SendToEmail, SubjectText, BodyText, true, CCEmail, BCCEmail);
                GetAttachment(ParCustomerNo, ParEntryNoText, EmailMessage);

                //Send mail
                //Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                Email.OpenInEditorModally(EmailMessage, Enum::"Email Scenario"::Default);
            end;
        end;
    END;
}