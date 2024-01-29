pageextension 71357863 "PostedPayRec_VSL" extends "Posted Payment Reconciliations"
{

    actions
    {
        addafter(Print)
        {
            action(Reverse_VSL)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reverse Test';
                Image = Undo;
                ToolTip = 'Undo the bank statement, unapply, and reverse the entries created by this journal.';

                trigger OnAction()
                var
                    ReversePaymentRecJournal: Codeunit ReversePaymentJo_VSL;
                begin
                    ReversePaymentRecJournal.RunReversalWizard(Rec);
                end;
            }
        }
    }
}