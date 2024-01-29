page 71357861 "RelatedPartyNameMapping_VSL"
{

    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;
    Caption = 'Related Party Name Mapping';
    CardPageID = RelatedPartyNameMapping_VSL;
    Editable = true;
    PageType = List;
    SourceTable = RelatedPartyNameMapping_VSL;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Related-Party Name_VSL"; Rec."Related-Party Name_VSL")
                {
                    ToolTip = 'Related-Party Name';
                    Caption = 'Related-Party Name';
                    ApplicationArea = All;
                }
                field("Account type_VSL"; Rec."Account type_VSL")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Account type';
                    Caption = 'Account type';

                }
                field("Account No._VSL"; Rec."Account No._VSL")
                {
                    ToolTip = 'Account No.';
                    Caption = 'Account No.';
                    ApplicationArea = Basic, Suite;
                }
                field("Bank account No._VSL"; Rec."Bank account No._VSL")
                {
                    ToolTip = 'Bank account No.';
                    Caption = 'Bank account No.';
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }


}