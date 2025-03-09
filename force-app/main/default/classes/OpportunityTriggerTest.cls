@IsTest
private class OpportunityTriggerTest {
    @IsTest
    private static void testOpportunityTrigger() {
        // テストデータの準備 (Prospecting)
        User testUser = [SELECT Id FROM User LIMIT 1];
        Opportunity testOpp = new Opportunity(
            Name = 'test opp',
            CloseDate = Date.today().addMonths(1),
            StageName = 'Prospecting',
            OwnerId = testUser.Id
        );
        insert testOpp;

        // テスト実行
        Test.startTest();
            testOpp.StageName = 'Qualification';
            update testOpp;
        Test.stopTest();

        // アサーション (件名が「商談先の調査のお願い」のタスクが1つ作成されるはず)
        List<Task> createadTaskList = [SELECT Id, Subject FROM Task WHERE WhatId = :testOpp.Id];
        Assert.areEqual(1, createadTaskList.size(), 'タスクの数が違います。');
    }
}