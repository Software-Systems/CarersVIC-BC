codeunit 50101 "CU for Sales Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Report Selections", 'OnBeforeGetCustEmailAddress', '', false, false)]
    local procedure OnBeforeGetCustEmailAddress(BillToCustomerNo: Code[20]; var ToAddress: Text; ReportUsage: Option; var IsHandled: Boolean)
    var
        ReportUsageLocal: Enum "Report Selection Usage";
        RecCustomer: Record Customer;
    begin
        if ReportUsage = 2 then begin
            If RecCustomer.Get(BillToCustomerNo) then begin
                ToAddress := RecCustomer."Invoice Recipient Email";
                IsHandled := true;
            end;
        end
    end;


}