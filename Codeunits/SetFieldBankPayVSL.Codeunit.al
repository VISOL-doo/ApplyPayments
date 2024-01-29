codeunit 71357864 "SetFieldBankPay_VSL"
{
    Permissions = TableData 274 = rimd;

    procedure SetFields_VSL(BankRecLine: Record "Bank Acc. Reconciliation Line"; AccountNo: code[20]; AccountType: Enum "Matching Ledger Account Type")
    begin
        BankRecLine.validate(BankRecLine."Account Type", AccountType);
        BankRecLine.Modify();
        BankRecLine.validate(BankRecLine."Account No.", AccountNo);
        BankRecLine.Modify();
    end;
}