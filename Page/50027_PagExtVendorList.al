pageextension 50027 "Vendor List Ext" extends "Vendor List"
{
    layout
    {
        addafter("No.")
        {
            field("Remittance Recipient Email"; Rec."Remittance Recipient Email")
            {
                Caption = 'Remittance Recipient Email';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(ApplyTemplate)
        {
            action(ImportVendors)
            {
                Caption = 'Import Vendors';
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
        BlockedBool: Enum "Vendor Blocked";
        Vendor: Record Vendor;
        Vendor1: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
        VendorBankAccount1: Record "Vendor Bank Account";

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
            if not Vendor1.Get(GetValueAtCell(RowNo, 1)) then begin

                Vendor.Init();
                Vendor.Validate("No.", GetValueAtCell(RowNo, 1));
                Vendor.Insert();

                if not VendorBankAccount1.Get(GetValueAtCell(RowNo, 1)) then begin
                    VendorBankAccount.Init();
                    VendorBankAccount.Validate("Vendor No.", GetValueAtCell(RowNo, 1));
                    VendorBankAccount.Validate(Code, GetValueAtCell(RowNo, 1));
                    VendorBankAccount.Insert();
                    VendorBankAccount.Validate("Bank Branch No.", GetValueAtCell(RowNo, 21));
                    VendorBankAccount.Validate("Bank Account No.", GetValueAtCell(RowNo, 22));
                    VendorBankAccount.Modify();
                    Commit();
                end;

                Vendor.Validate(Name, GetValueAtCell(RowNo, 2));
                Vendor.Validate("Name 2", GetValueAtCell(RowNo, 3));
                Vendor.Validate(Address, GetValueAtCell(RowNo, 4));
                Vendor.Validate("Address 2", GetValueAtCell(RowNo, 5));
                Vendor.Validate(City, GetValueAtCell(RowNo, 7));
                Vendor.Validate(Contact, GetValueAtCell(RowNo, 8));
                Vendor.Validate("Post Code", GetValueAtCell(RowNo, 9));
                Vendor.Validate(County, GetValueAtCell(RowNo, 10));
                Vendor.Validate("Country/Region Code", GetValueAtCell(RowNo, 17));
                Vendor.Validate("E-Mail", GetValueAtCell(RowNo, 11));
                Vendor.Validate("Phone No.", GetValueAtCell(RowNo, 12));
                Vendor.Validate("Mobile Phone No.", GetValueAtCell(RowNo, 13));
                Vendor.Validate("Global Dimension 1 Code", GetValueAtCell(RowNo, 14));
                Vendor.Validate("Global Dimension 2 Code", GetValueAtCell(RowNo, 15));

                if GetValueAtCell(RowNo, 16) = 'DOMESTIC' then
                    Vendor.Validate("Vendor Posting Group", 'LOCAL')
                else
                    Vendor.Validate("Vendor Posting Group", GetValueAtCell(RowNo, 16));

                Evaluate(BlockedBool, GetValueAtCell(RowNo, 18));
                Vendor.Validate(Blocked, BlockedBool);
                Vendor.Validate("Pay-to Vendor No.", GetValueAtCell(RowNo, 19));
                Vendor.Validate("Payment Method Code", GetValueAtCell(RowNo, 20));
                Vendor.Validate("EFT Bank Account No.", GetValueAtCell(RowNo, 1));
                Vendor.Validate(ABN, DelChr(GetValueAtCell(RowNo, 23), '=', ' '));

                if GetValueAtCell(RowNo, 24) = 'DOMESTIC' then
                    Vendor.Validate("Gen. Bus. Posting Group", 'LOCAL')
                else
                    Vendor.Validate("Gen. Bus. Posting Group", GetValueAtCell(RowNo, 24));

                if GetValueAtCell(RowNo, 25) = 'DOMESTIC' then
                    Vendor.Validate("VAT Bus. Posting Group", 'LOCAL')
                else
                    Vendor.Validate("VAT Bus. Posting Group", GetValueAtCell(RowNo, 25));

                Vendor.Validate("Remittance Recipient Email", GetValueAtCell(RowNo, 26));
                Vendor.Modify();


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