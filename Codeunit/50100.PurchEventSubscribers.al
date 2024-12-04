codeunit 50100 "CU for Purchase Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Report Selections", 'OnBeforeGetVendorEmailAddress', '', false, false)]
    local procedure OnBeforeGetVendorEmailAddress(BuyFromVendorNo: Code[20]; var ToAddress: Text; ReportUsage: Option; var IsHandled: Boolean; RecVar: Variant)
    var
        ReportUsageLocal: Enum "Report Selection Usage";
        RecVendor: Record Vendor;
    begin
        if (ReportUsage = 86) or (ReportUsage = 84) then begin
            If RecVendor.Get(BuyFromVendorNo) then begin
                ToAddress := RecVendor."Remittance Recipient Email";
                IsHandled := true;
            end;
        end
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", 'OnAfterGetEmailSubject', '', false, false)]
    local procedure OnAfterGetEmailSubject(PostedDocNo: Code[20]; EmailDocumentName: Text[250]; ReportUsage: Integer; var EmailSubject: Text[250])
    var
        cust: Record Customer;
    begin
        // To send the remittance advice email with different Subject
        // Sales Invoice Report No 2
        // Remittance Advice from VLE - Report No - 84
        // Remittance Advice from Payment Journal - Report No - 86
        if (ReportUsage = 84) or (ReportUsage = 86) then
            EmailSubject := 'Carers Victoria Limited: Remittance Advice ' + PostedDocNo;
    end;

}