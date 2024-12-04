pageextension 50022 "Cusomer List Ext" extends "Customer List"
{
    layout
    {
        addafter("No.")
        {
            field("Invoice Recipient Email"; Rec."Invoice Recipient Email")
            {
                Caption = 'Invoice Recipient Email';
                ApplicationArea = All;

            }
        }
    }
    actions
    {
        addafter(ApplyTemplate)
        {
            action(ImportCustomers)
            {
                Caption = 'Import Customers';
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    ExcelBuffer: Record "Excel Buffer";

                begin
                    ReadExcelSheet();
                    ImportExcelData();

                end;
            }
        }
    }
    Procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    procedure ImportExcelData()
    var
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
        InvDelMethod: Enum "Invoice Delivery Method";
        Customer: Record Customer;
        Customer1: Record Customer;
        CreditLimitDec: Decimal;
        BlockedBool: Enum "Customer Blocked";

    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;


        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        for RowNo := 2 to MaxRowNo do begin
            if not Customer1.Get(GetValueAtCell(RowNo, 1)) then begin

                Customer.Init();
                Customer.Validate("No.", GetValueAtCell(RowNo, 1));
                Customer.Insert();


                Customer.Validate(Name, GetValueAtCell(RowNo, 2));
                Customer.Validate("Name 2", GetValueAtCell(RowNo, 3));
                Customer.Validate(Address, GetValueAtCell(RowNo, 4));
                Customer.Validate("Address 2", GetValueAtCell(RowNo, 5));
                Customer.Validate(City, GetValueAtCell(RowNo, 7));
                Customer.Validate(Contact, GetValueAtCell(RowNo, 10));
                Customer.Validate("Post Code", GetValueAtCell(RowNo, 8));
                Customer.Validate(County, GetValueAtCell(RowNo, 9));
                Customer.Validate("Country/Region Code", GetValueAtCell(RowNo, 21));
                Customer.Validate("E-Mail", GetValueAtCell(RowNo, 13));
                Customer.Validate("Phone No.", GetValueAtCell(RowNo, 11));
                Customer.Validate("Mobile Phone No.", GetValueAtCell(RowNo, 12));
                Customer.Validate("Global Dimension 1 Code", GetValueAtCell(RowNo, 15));
                Customer.Validate("Global Dimension 2 Code", GetValueAtCell(RowNo, 16));
                Evaluate(InvDelMethod, GetValueAtCell(RowNo, 14));
                Customer.Validate("Invoice Delivery method", InvDelMethod);
                if GetValueAtCell(RowNo, 17) <> '' then begin
                    Evaluate(CreditLimitDec, GetValueAtCell(RowNo, 17));
                    Customer.Validate("Credit Limit (LCY)", CreditLimitDec);
                end;
                Customer.Validate("Customer Posting Group", GetValueAtCell(RowNo, 18));
                Customer.Validate("Payment Terms Code", GetValueAtCell(RowNo, 19));
                Customer.Validate("Salesperson Code", GetValueAtCell(RowNo, 20));
                Evaluate(BlockedBool, GetValueAtCell(RowNo, 22));
                Customer.Validate(Blocked, BlockedBool);
                Customer.Validate("Payment Method Code", GetValueAtCell(RowNo, 23));
                Customer.Validate("VAT Registration No.", GetValueAtCell(RowNo, 24));
                Customer.Validate("Gen. Bus. Posting Group", GetValueAtCell(RowNo, 25));
                Customer.Validate("VAT Bus. Posting Group", GetValueAtCell(RowNo, 26));
                Customer.Validate("Invoice Recipient Email", GetValueAtCell(RowNo, 27));
                Customer.Modify();


            end;
        end;
        Message(ExcelImportSucess);
    end;



    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    var
        FileName: Text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSucess: Label 'Excel is successfully imported.';
}