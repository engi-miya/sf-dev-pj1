global class OpportunityFollowUpBatch implements Database.Batchable<SObject> {
    // 1. バッチ処理対象の商談レコード取得
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            [SELECT Id, OwnerId FROM Opportunity
             WHERE StageName = 'Qualification']);
    }
    // 2. 取得した商談レコードをバッチ処理
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Task> taskList = new List<Task>();
        // 各商談に対してタスクレコードを作成
        for (Opportunity opp : (List<Opportunity>)scope) {
            Task task = new Task(
                Subject = '商談先の調査のお願い',
                Status = 'Not Started',
                ActivityDate = Date.today().addDays(7),
                WhatId = opp.Id,
                OwnerId = opp.OwnerId
            );
            taskList.add(task);
        }
        // タスクレコードが空でなければinsert
        if (!taskList.isEmpty()) {
            insert taskList;
        }
    }
    // 3. バッチ処理完了処理
    global void finish(Database.BatchableContext bc) {
        System.debug('バッチ処理が完了しました！');
    }
}