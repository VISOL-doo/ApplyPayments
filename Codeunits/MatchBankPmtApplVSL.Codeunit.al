codeunit 71357862 "Match Bank Pmt. Appl._VSL"
{
    TableNo = "Bank Acc. Reconciliation";

    trigger OnRun()
    var
        MatchBankPayments: Codeunit MatchBankPay_VSL;
    begin
        BankAccReconciliationLine.FilterBankRecLines(Rec);
        if BankAccReconciliationLine.FindFirst then begin
            MatchBankPayments.SetApplyEntries(true);
            MatchBankPayments.Run(BankAccReconciliationLine);
        end;
        OnAfterMatchBankPayments(Rec);
    end;

    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";

    procedure MatchNoOverwriteOfManualOrAccepted(BankAccReconciliation: Record "Bank Acc. Reconciliation")
    var
        MatchBankPayments: Codeunit MatchBankPay_VSL;
    begin
        BankAccReconciliationLine.FilterBankRecLines(BankAccReconciliation);
        if BankAccReconciliationLine.FindFirst() then begin
            MatchBankPayments.SetApplyEntries(true);
            MatchBankPayments.MatchNoOverwriteOfManualOrAccepted(BankAccReconciliationLine);
        end;
        OnAfterMatchBankPayments(BankAccReconciliation);
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterMatchBankPayments(var BankAccReconciliation: Record "Bank Acc. Reconciliation")
    begin
    end;

    [EventSubscriber(ObjectType::Table, 8631, 'OnDoesTableHaveCustomRuleInRapidStart', '', false, false)]
    //[Scope('OnPrem')]
    procedure CheckBankAccRecOnDoesTableHaveCustomRuleInRapidStart(TableID: Integer; var Result: Boolean)
    begin
        if TableID = DATABASE::"Bank Acc. Reconciliation" then
            Result := true;
    end;
}

