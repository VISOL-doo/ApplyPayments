permissionset 71357860 "GePerm_VSL"
{
    Assignable = true;
    Permissions =
        tabledata RelatedPartyNameMapping_VSL = RIMD,
        table RelatedPartyNameMapping_VSL = X,
        codeunit "GetBankStmt.LineCandidates_VSL" = X,
        codeunit "Match Bank Pmt. Appl._VSL" = X,
        codeunit MatchBankPay_VSL = X,
        page PaymentApplication_VSL = X,
        page RelatedPartyNameMapping_VSL = X;
}