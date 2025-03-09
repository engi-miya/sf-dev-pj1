trigger OpportunityTrigger on Opportunity (after update) {
    // ユーザーを取得。見つからなかった場合はエラーを返す。
    User user;
    try {
        user = [SELECT Id FROM User WHERE Username = 'test-fxiucqrq5eng@example.com' LIMIT 1];        
    } catch (Exception e) {
        System.debug('User not found: ' + e.getMessage());
        return;
    }

    // oppList 更新されたレコードを取得する
    List<Task> taskList = new List<Task>();
    for (Opportunity opp : Trigger.new) {
        Opportunity oldOpp = Trigger.oldMap.get(opp.Id);
        // 更新前の商談状況と更新後の商談状況を比較 (更新前がProspecting、更新後がQualification)の場合
        if (oldOpp.StageName == 'Prospecting' && opp.StageName == 'Qualification') {
            // Taskを作成 
            Task task  = new Task(
                Subject = '商談先の調査のお願い',
                Status = 'Not Started',
                ActivityDate = Date.today().addDays(7),
                WhatId = opp.Id,
                OwnerId = user.Id
            );
            taskList.add(task);
        }
    }
    insert taskList;
}