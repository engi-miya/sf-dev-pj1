@IsTest
private class OpportunityFollowUpBatchTest {
    @IsTest
    private static void testOpportunityFollowUpBatch() {
        // テスト用のデータ準備
        List<Opportunity> testOppList = new List<Opportunity>();
        User testUser = [SELECT Id FROM User LIMIT 1];
        for (Integer i = 0; i < 3; i++) {
            Opportunity testOpp = new Opportunity(
                Name = 'test' + i,
                StageName = 'Qualification',
                CloseDate = Date.today().addDays(10),
                OwnerId = testUser.Id
            );
            testOppList.add(testOpp);
        }
        insert testOppList;
        System.debug('商談レコードの数は' + testOppList.size());
        
        // コードの実行
        Test.startTest();
        OpportunityFollowUpBatch batch = new OpportunityFollowUpBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();
        
        // アサーション
        List<Task> creatadTaskList = [SELECT Id FROM Task WHERE Subject = '商談先の調査のお願い'];
        System.debug('タスクレコードの数は' + creatadTaskList.size());
        Assert.areEqual(3, creatadTaskList.size(), 'バッチ処理が行われていません。');
    }
}