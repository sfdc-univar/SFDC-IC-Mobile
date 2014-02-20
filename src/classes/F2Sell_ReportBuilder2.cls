public with sharing class F2Sell_ReportBuilder2
{
    public UserRole currentRole {set;get;}
    public String currentRoleId 
    {
        get 
        {
            return String.valueOf(currentRole.Id).left(15);
        }
    }
    public String parentRoleId  
    {
       get 
       {
            return String.valueOf(roleMap.get(currentRole.ParentRoleId).Id).left(15);
       } 
    }
    public UserRole parentRole 
    {
        set;
        get 
        {
            return roleMap.get(currentRole.ParentRoleId);
        }
    }
    Date last26Weeks = date.today().toStartOfWeek().addDays(-182);
    Date currentMonth = date.today().toStartOfMonth().addDays(-1);
    Date previous4Weeks = date.today().toStartOfWeek().addDays(-28);
    Date previous3Weeks = date.today().toStartOfWeek().addDays(-21);
    Date previous2Weeks = date.today().toStartOfWeek().addDays(-14);
    Date previous1Weeks = date.today().toStartOfWeek().addDays(-7);
    Date currentWeekStart = date.today().toStartOfWeek();
    Date currentWeek = date.today().toStartOfWeek().addDays(7);
    Date nextWeek = date.today().toStartOfWeek().addDays(14);
    //Parent Id, child roles
    public Map<String, List<UserRole>> roleHierarchy {get; private set;}
    public Map<Id, UserRole> roleMap {get; private set;}
    //holds the User data, by Id
    public Map<Id, User> userMap {get; private set;}
    //Child roles, for the current selected node
    public List<UserRole> childRoleHierarchy {get; private set;}
	
    public String selectedRoleId {get {
                                        if(this.selectedRoleId!=null && this.selectedRoleId.length()>15) {
                                            return this.selectedRoleId.left(15);    
                                        }
                                        else {
                                            return this.selectedRoleId; 
                                        }
                                            
                                    } 
        
                                    set;}
    public Map<String, ReportDataRow> summaryRowMap {get; set;}
    public Map<String, AccountPriority> accountPriorityMap {get; set;}
    public List<AccountPriority> accountPriorityList {get; set;}
    
    @TestVisible private Transient Map<Id, ReportDataRow> filteredCppData {get; set;}
    public Transient List<ReportDataRow> filteredCppDataList {get; set;} 
    
    @TestVisible private Transient Map<Id, ReportDataRow> filteredCppLbsData {get; set;} 
    public Transient List<ReportDataRow> filteredCppLbsDataList {get; set;}
    
    @TestVisible private Transient Map<Id, ReportDataRow> filteredOppsData {get; set;} 
    public Transient List<ReportDataRow> filteredOppsDataList {get; set;}
    
    @TestVisible private Transient Map<Id, ReportDataRow> filteredCallsData {get; set;}
    public Transient List<ReportDataRow> filteredCallsDataList {get; set;}
    
    @TestVisible private Transient Map<Id, ReportDataRow> filteredOppDollarData {get; set;} 
    public Transient List<ReportDataRow> filteredOppDollarDataList {get; set;} 
	
	//NEW///
	@TestVisible private Transient Map<Id, ReportDataRow> filteredOppClosedWonDollarData { get; Set; }
	public Transient List<ReportDataRow> filteredOppClosedWonDollarList { get; Set; }
    
	@TestVisible private Transient Map<Id, ReportDataRow> filteredOppClosedWonData { get; Set; }
	public Transient List<ReportDataRow> filteredOppClosedWonList { get; Set; }
	//END NEW///
	
    //This stores the users in lists categorized by role
    public Map<Id, List<User>> usersByRole = new Map<Id, List<User>>();
    public Boolean bRenderHyperLinks { get; Set; }
	
    public F2Sell_ReportBuilder2() 
    {
		currentRole = getUserRole(Userinfo.getUserRoleId());
		setRoleHierarchy(currentRole.Id);
        childRoleHierarchy = roleHierarchy.get(currentRoleId);
		bRenderHyperLinks = false;
        selectedRoleId = currentRoleId;
        setUserData();
        buildUsersByRole();
        filteredCallsData = new Map<Id, ReportDataRow>();
        filteredCallsDataList = new List<ReportDataRow>();
        summaryRowMap = new Map<String, ReportDataRow>();
        summaryRowMap.put('calls', new ReportDataRow());
        summaryRowMap.put('targetCalls', new ReportDataRow());
        summaryRowMap.put('oppCounts', new ReportDataRow());
        summaryRowMap.put('oppDollars', new ReportDataRow());
        summaryRowMap.put('cppCounts', new ReportDataRow());
        summaryRowMap.put('cppLbs', new ReportDataRow());
		// NEW ////
		summaryRowMap.put('oppsWon', new ReportDataRow());
		summaryRowMap.put('oppsWonDollars', new ReportDataRow());		
		// END NEW ///
        accountPriorityMap = new Map<String, AccountPriority>();
        accountPriorityList = new List<AccountPriority>();
        accountPriorityMap.put('Estimated Potential', new AccountPriority());
    }
    
    private UserRole getUserRole(String userRoleId) 
    {
        return [SELECT Id, Name, ParentRoleId  FROM UserRole WHERE Id = :userRoleId];
    }
    
    private List<User> getUserIds()
    {
        return [SELECT Id, Name, UserRoleId FROM User WHERE UserRoleId IN :roleMap.keySet() AND isActive = true];
    }
    
    private void setUserData()
    {
        this.userMap = new Map<Id, User>([SELECT Id, Name, UserRoleId FROM User WHERE UserRoleId IN :roleMap.keySet() AND isActive = true ORDER BY Name]);
    }
    
    private Boolean getIsUserLowestNode() 
    {
        //if the current node is the lowest node, i.e. it is not a parent AND the user is in that role, only show their records
        if(roleHierarchy.get(this.selectedRoleId)==NULL && String.valueOf(UserInfo.getUserRoleId()).left(15) == this.selectedRoleId) 
        {
            return true;
        }
        return false;
    }
    
    private void buildUsersByRole()
    {
        for(User u : userMap.values()) {
            if(usersByRole.get(u.UserRoleId)==NULL)
                usersByRole.put(u.UserRoleId, new List<User>());
            usersByRole.get(u.UserRoleId).add(u);   
        }   
    }
    
    private List<User> getUsersByRole(Set<String> roleId)
    {
        List<User> temp = new List<User>();
        List<String> sortThis = new List<String>();
        for(String Id: roleId)
        {
            if(usersByRole.containsKey(Id)) {
                temp.addAll(usersByRole.get(Id));
            }
        }
        temp.sort();
        return temp;
    }
    
    //Use the currently selected role to determine sub roles
    private Set<String> getFilteredSubRoleIds(Set<String> roleIds) {
        Set<String> currentRoleIds = new Set<String>();
        
        // get all of the roles underneath the passed roles
        for(String roleId : roleIds) {
            if(this.roleHierarchy.get(roleId)!=null) {
                for(UserRole userRole : this.roleHierarchy.get(roleId)) {
                    currentRoleIds.add(String.valueOf(userRole.Id).left(15));
                }
            }
        }
        if(currentRoleIds.size() > 0)
          currentRoleIds.addAll(getFilteredSubRoleIds(currentRoleIds));
        return currentRoleIds;
        
    }
    
    private void getCallsData(String selectedRoleId) 
    {
        summaryRowMap.put('calls', new ReportDataRow());
        summaryRowMap.put('targetCalls', new ReportDataRow());
        //first get the set of role ids, beneath and including the current role:
        Set<String> filteredRoleIds = getFilteredSubRoleIds(new Set<String>{selectedRoleId.left(15)}); 
        filteredRoleIds.add(String.valueOf(currentRole.Id).left(15));
		List<User> usersFromRoles = this.getUsersByRole(filteredRoleIds);
		Map<String,User> mappedUsersInRole = new Map<String,User>();
		for(User u: usersFromRoles)
			mappedUsersInRole.put(String.valueOf(u.Id).left(15),u);
        List<F2S_Activity_Snapshot__c> calls = 
        [
            SELECT Id, User_ID__c, Role_ID__c, Count__c, Target_Count__c, Date__c 
            FROM F2S_Activity_Snapshot__c 
            //WHERE Role_ID__c in :filteredRoleIds 
			WHERE User_ID__c IN: mappedUsersInRole.keySet()
            AND Date__c >= :previous4Weeks 
            AND Date__c < :currentWeekStart
            AND Role_ID__c != null 
            AND User_ID__c != null
            AND Date__c != null 
            ORDER BY User_ID__c 
        ];
        
        //Now we have everything, sort by RoleId and create some lists, this will make subsequent calls easier
        Boolean isUserLowestNode = getIsUserLowestNode();
        //Reinitialize
        this.filteredCallsData = new Map<Id, ReportDataRow>();
        this.filteredCallsDataList = new List<ReportDataRow>();
        //match the roles to the users here, pass in role ids, returns a list of filtered users based on currently selected hierarchy.

        ReportDataRow summary = new ReportDataRow();
        ReportDataRow targetSummary = new ReportDataRow();
        List<User> allUsersInRole = usersFromRoles;//getUsersByRole(roleIds);
        /*Map<String,User> mappedUsersInRole = new Map<String,User>();
        for(User u: allUsersInRole)
        {
            mappedUsersInRole.put(String.valueOf(u.Id).left(15),u);
        }*/
        //Always add a row for the current user
        if(isUserLowestNode)
        {
            ReportDataRow rdr = new ReportDataRow();
            rdr.userName = UserInfo.getName();
            this.filteredCallsData.put(UserInfo.getUserId(), rdr); 
            this.filteredCallsDataList.add(rdr);
        }
        else
        {
            if(allUsersInRole.size() > 0)
            {
                if(mappedUsersInRole != null)
                {
                    for(User u : allUsersInRole)
                    {
                        ReportDataRow rdr = new ReportDataRow();
                        rdr.userName = u.Name;
                        this.filteredCallsData.put(u.Id, rdr);
                        this.filteredCallsDataList.add(rdr);
                    }
                }
            }
        }
        
        AggregateResult[] userSummaryResult  = [SELECT User_ID__c userId, SUM(Count__c) totalCount, SUM(Target_Count__c) targetCount
                                                FROM F2S_Activity_Snapshot__c 
                                                    //WHERE Role_ID__c in :filteredRoleIds 
                                                    WHERE User_ID__c IN: mappedUsersInRole.keySet()
														AND Date__c >= :last26Weeks
                                                    	AND Date__c < :currentWeekStart
                                                    	AND Role_ID__c != null 
											            AND User_ID__c != null
											            AND Date__c != null 
                                                    		GROUP BY User_ID__c];
        Map<String, AggregateResult> userSummaryMap = new Map<String, AggregateResult>();
        for(AggregateResult ar : userSummaryResult) {
			if(mappedUsersInRole != null && mappedUsersInRole.containsKey((String)ar.get('userId')))
			{
				userSummaryMap.put((String)ar.get('userId'), ar);
				summary.setCountAndAverage((Decimal)ar.get('totalCount'));
	            targetSummary.setCountAndAverage((Decimal)ar.get('targetCount'));
	            ReportDataRow userRdr = this.filteredCallsData.get((String)ar.get('userId'));
	            if(userRdr!=NULL) 
	            {
	            	userRdr.setCountAndAverage((Decimal)ar.get('totalCount'));
	            }
			}
        }
        	
        if(calls.size()>0)
        {
            for(F2S_Activity_Snapshot__c call : calls) 
            {
                if(call.Count__c == null)
                    call.Count__c = 0;
                if(call.Target_Count__c == null)
                    call.Target_Count__c = 0;    
                if(mappedUsersInRole != null && mappedUsersInRole.containsKey(call.User_ID__c))
                {
                    if(isUserLowestNode && call.User_ID__c != UserInfo.getUserId().left(15))
                        continue;
                                            
                    ReportDataRow userRdr = this.filteredCallsData.get(call.User_ID__c);
                    if(userRdr != null)
                    { 
						if(call.Date__c >= previous4Weeks && call.Date__c < currentWeekStart) 
                        {
                            userRdr.weekSummaryMetric4 += (call.Count__c * 0.25);
                            summary.weekSummaryMetric4 += (call.Count__c * 0.25);
							targetSummary.weekSummaryMetric4 += (call.Target_Count__c * 0.25);
                        }
                        if(call.Date__c >= previous4Weeks&&call.Date__c < previous3Weeks) 
                        {
                            userRdr.weekPreviousValue4 += call.Count__c;
                            summary.weekPreviousValue4 += call.Count__c;
                            targetSummary.weekPreviousValue4 += call.Target_Count__c;
                        }
                        else if(call.Date__c >= previous3Weeks&&call.Date__c < previous2Weeks) 
                        {
                            userRdr.weekPreviousValue3 += call.Count__c;
                            summary.weekPreviousValue3 += call.Count__c;
                            targetSummary.weekPreviousValue3 += call.Target_Count__c;                            
                        }
                        else if(call.Date__c >= previous2Weeks && call.Date__c < previous1Weeks) 
                        {
                            userRdr.weekPreviousValue2 += call.Count__c;
                            summary.weekPreviousValue2 += call.Count__c;
                            targetSummary.weekPreviousValue2 += call.Target_Count__c;                            
                        }
                        else if(call.Date__c >= previous1Weeks && call.Date__c < currentWeekStart) 
                        {
                            userRdr.weekPreviousValue1 += call.Count__c;
                            summary.weekPreviousValue1 += call.Count__c;
                            targetSummary.weekPreviousValue1 += call.Target_Count__c;                            
                        }
                    }
                }
            }
            summary.userCount = allUsersInRole.size();
            targetSummary.userCount = allUsersInRole.size();
            
			//summary.weekSummaryMetric4 = (summary.weekPreviousValue1 + summary.weekPreviousValue2 + summary.weekPreviousValue3 + summary.weekPreviousValue4) * 0.25;
            if(summary.userCount>0)
            {
	            summary.calculateAverages();
			}
            summary.weekSummaryMetric4 = (summary.weekPreviousValue4SummaryMetric + summary.weekPreviousValue3SummaryMetric + summary.weekPreviousValue2SummaryMetric + summary.weekPreviousValue1SummaryMetric) / 4;
			summary.weekSummaryMetric4 = summary.weekSummaryMetric4.setScale(2, RoundingMode.HALF_UP);
            summaryRowMap.put('calls', summary);
            
			//targetSummary.weekSummaryMetric4 = (targetSummary.weekPreviousValue1 + targetSummary.weekPreviousValue2 + targetSummary.weekPreviousValue3 + targetSummary.weekPreviousValue4) * 0.25;
            if(targetSummary.userCount>0)
            {
                targetSummary.calculateAverages();
		    }
            calculateTargetSummaryPercentages(targetSummary, summary);
			targetSummary.weekSummaryMetric4 = (targetSummary.weekPreviousValue4SummaryMetric + targetSummary.weekPreviousValue3SummaryMetric + targetSummary.weekPreviousValue2SummaryMetric + targetSummary.weekPreviousValue1SummaryMetric) / 4;
			targetSummary.weekSummaryMetric4 = targetSummary.weekSummaryMetric4.setScale(2, RoundingMode.HALF_UP);
            summaryRowMap.put('targetCalls', targetSummary);
        }
    }
    
    private void getOppCountData(String selectedRoleId) 
    {
        summaryRowMap.put('oppCounts', new ReportDataRow());
        //first get the set of role ids, beneath and including the current role:
        Set<String> filteredRoleIds = getFilteredSubRoleIds(new Set<String>{selectedRoleId.left(15)}); 
        filteredRoleIds.add(String.valueOf(currentRole.Id).left(15));
		List<User> usersFromRoles = this.getUsersByRole(filteredRoleIds);
		Map<String,User> mappedUsersInRole = new Map<String,User>();
		for(User u: usersFromRoles)
			mappedUsersInRole.put(String.valueOf(u.Id).left(15),u);
        List<F2S_Opportunity_Snapshot__c> opps = [
                                                    SELECT Id, User_ID__c, Role_ID__c, Count__c, Date__c, Stage__c
                                                    FROM F2S_Opportunity_Snapshot__c 
                                                    //WHERE Role_ID__c in :filteredRoleIds 
													WHERE User_ID__c IN: mappedUsersInRole.keySet()
                                                    AND Date__c >= :previous4Weeks
                                                    AND Date__c < :currentWeekStart
                                                    AND Role_ID__c != null 
                                                    AND User_ID__c != null
                                                    AND Date__c != null
                                                    AND Count__c != null
													AND Stage__c = NULL
                                                    ORDER BY User_ID__c 
                                                ];
        
        //Now we have everything, sort by RoleId and create some lists, this will make subsequent calls easier
        Boolean isUserLowestNode = getIsUserLowestNode();
        Set<String> roleIds = getFilteredSubRoleIds(new Set<String>{String.valueOf(this.selectedRoleId)});
     
        //Reinitialize
        this.filteredOppsData = new Map<Id, ReportDataRow>();
        this.filteredOppsDataList = new List<ReportDataRow>();
        roleIds.add(this.selectedRoleId);
        //match the roles to the users here, pass in role ids, returns a list of filtered users based on currently selected hierarchy.

        ReportDataRow summary = new ReportDataRow();
        List<User> allUsersInRole = usersFromRoles;//getUsersByRole(roleIds);
        /*Map<String,User> mappedUsersInRole = new Map<String,User>();
        for(User u: allUsersInRole)
        {
            mappedUsersInRole.put(String.valueOf(u.Id).left(15),u);
        }*/
        //Always add a row for the current user
        if(isUserLowestNode)
        {
            ReportDataRow rdr = new ReportDataRow();
            rdr.userName = UserInfo.getName();
            this.filteredOppsData.put(UserInfo.getUserId(), rdr); 
            this.filteredOppsDataList.add(rdr);
        }
        else
        {
            if(allUsersInRole.size() > 0)
            {
                if(mappedUsersInRole != null)
                {
                    for(User u : allUsersInRole)
                    {
                        ReportDataRow rdr = new ReportDataRow();
                        rdr.userName = u.Name;
                        this.filteredOppsData.put(u.Id, rdr);
                        this.filteredOppsDataList.add(rdr); 
                    }
                }
            }
        } 
        
        AggregateResult[] userSummaryResult  = [SELECT User_ID__c userId, SUM(Count__c) totalCount
                                                FROM F2S_Opportunity_Snapshot__c 
                                                    //WHERE Role_ID__c in :filteredRoleIds 
                                                    WHERE User_ID__c IN: mappedUsersInRole.keySet()
														AND Date__c >= :last26Weeks
                                                    	AND Date__c < :currentWeekStart
                                                    	AND Role_ID__c != null 
											            AND User_ID__c != null
											            AND Date__c != null 
														AND Stage__c = NULL
                                                    		GROUP BY User_ID__c];
        Map<String, AggregateResult> userSummaryMap = new Map<String, AggregateResult>();
        for(AggregateResult ar : userSummaryResult) {
        	if(mappedUsersInRole != null && mappedUsersInRole.containsKey((String)ar.get('userId')))
			{
				userSummaryMap.put((String)ar.get('userId'), ar);
				summary.setCountAndAverage((Decimal)ar.get('totalCount'));
	            ReportDataRow userRdr = this.filteredOppsData.get((String)ar.get('userId'));
	            if(userRdr!=NULL) 
	            {
	            	userRdr.setCountAndAverage((Decimal)ar.get('totalCount'));
	            }
			}
        }
        
        if(opps.size() > 0)
        {
            for(F2S_Opportunity_Snapshot__c opp : opps) 
            {
                if(mappedUsersInRole != null && mappedUsersInRole.containsKey(opp.User_ID__c))
                {
                    if(isUserLowestNode && opp.User_ID__c != UserInfo.getUserId().left(15))
                        continue;
                                            
                    ReportDataRow userRdr = this.filteredOppsData.get(opp.User_ID__c);
                    if(userRdr != null)
                    { 
						if(opp.Date__c >= previous4Weeks && opp.Date__c < currentWeekStart) 
                        {
                            userRdr.weekSummaryMetric4 += (opp.Count__c * 0.25);
                            summary.weekSummaryMetric4 += (opp.Count__c * 0.25);
                        }
                        if(opp.Date__c >= previous4Weeks && opp.Date__c < previous3Weeks) 
                        {
                            userRdr.weekPreviousValue4 += opp.Count__c;
                            summary.weekPreviousValue4 += opp.Count__c;
                        }
                        else if(opp.Date__c >= previous3Weeks && opp.Date__c < previous2Weeks) 
                        {
                            userRdr.weekPreviousValue3 += opp.Count__c;
                            summary.weekPreviousValue3 += opp.Count__c;
                        }
                        else if(opp.Date__c >= previous2Weeks && opp.Date__c < previous1Weeks) 
                        {
                            userRdr.weekPreviousValue2 += opp.Count__c;
                            summary.weekPreviousValue2 += opp.Count__c;
                        }
                        else if(opp.Date__c >= previous1Weeks && opp.Date__c < currentWeekStart) 
                        {
                            userRdr.weekPreviousValue1 += opp.Count__c;
                            summary.weekPreviousValue1 += opp.Count__c;
                        }
                    }
                }
            }
            summary.userCount = allUsersInRole.size();
            
            if(summary.userCount>0)
            {
                summary.calculateAverages();
            }
            summaryRowMap.put('oppCounts', summary);
        }
    }
     
	private void getOppDollarData(String selectedRoleId) 
     {
        summaryRowMap.put('oppDollars', new ReportDataRow());
        //first get the set of role ids, beneath and including the current role:
        Set<String> filteredRoleIds = getFilteredSubRoleIds(new Set<String>{selectedRoleId.left(15)}); 
        filteredRoleIds.add(String.valueOf(currentRole.Id).left(15));
		List<User> usersFromRoles = this.getUsersByRole(filteredRoleIds);
		Map<String,User> mappedUsersInRole = new Map<String,User>();
		for(User u: usersFromRoles)
			mappedUsersInRole.put(String.valueOf(u.Id).left(15),u);
        List<F2S_Opportunity_Snapshot__c> opps = [
                                                    SELECT Id, User_ID__c, Role_ID__c, Est_Sales__c, Date__c, Stage__c 
                                                    FROM F2S_Opportunity_Snapshot__c 
                                                    //WHERE Role_ID__c in :filteredRoleIds 
													WHERE User_ID__c IN: mappedUsersInRole.keySet()
                                                    AND Date__c >= :previous4Weeks
                                                    AND Date__c < :currentWeekStart
                                                    AND Role_ID__c != null 
                                                    AND User_ID__c != null
                                                    AND Date__c != null
                                                    AND Est_Sales__c != null
													AND Stage__c = NULL
                                                    ORDER BY User_ID__c 
                                                ];
        
        //Now we have everything, sort by RoleId and create some lists, this will make subsequent calls easier
       
        Boolean isUserLowestNode = getIsUserLowestNode();
        Set<String> roleIds = getFilteredSubRoleIds(new Set<String>{String.valueOf(this.selectedRoleId)});
     
        //Reinitialize
        this.filteredOppDollarData = new Map<Id, ReportDataRow>();
        this.filteredOppDollarDataList = new List<ReportDataRow>();
        roleIds.add(this.selectedRoleId);
        //match the roles to the users here, pass in role ids, returns a list of filtered users based on currently selected hierarchy.
        ReportDataRow summary = new ReportDataRow();
        List<User> allUsersInRole = usersFromRoles;//getUsersByRole(roleIds);
        /*Map<String,User> mappedUsersInRole = new Map<String,User>();
        for(User u: allUsersInRole)
        {
            mappedUsersInRole.put(String.valueOf(u.Id).left(15),u);
        }*/
        //Always add a row for the current user
        if(isUserLowestNode)
        {
            ReportDataRow rdr = new ReportDataRow();
            rdr.userName = UserInfo.getName();
            this.filteredOppDollarData.put(UserInfo.getUserId(), rdr); 
            this.filteredOppDollarDataList.add(rdr);
        }
        else
        {
            if(allUsersInRole.size() > 0)
            {
                if(mappedUsersInRole != null)
                {
                    for(User u : allUsersInRole)
                    {
                        ReportDataRow rdr = new ReportDataRow();
                        rdr.userName = u.Name;
                        this.filteredOppDollarData.put(u.Id, rdr);
                        this.filteredOppDollarDataList.add(rdr); 
                    }
                }
            }
        }
        
        AggregateResult[] userSummaryResult  = [SELECT User_ID__c userId, SUM(Est_Sales__c) totalCount
                                                FROM F2S_Opportunity_Snapshot__c 
                                                    //WHERE Role_ID__c in :filteredRoleIds 
                                                    WHERE User_ID__c IN: mappedUsersInRole.keySet()
														AND Date__c >= :last26Weeks
                                                    	AND Date__c < :currentWeekStart
                                                    	AND Role_ID__c != null 
											            AND User_ID__c != null
											            AND Date__c != null
											            AND Est_Sales__c != null
														AND Stage__c = NULL
                                                    		GROUP BY User_ID__c];
        Map<String, AggregateResult> userSummaryMap = new Map<String, AggregateResult>();
        for(AggregateResult ar : userSummaryResult) {
			if(mappedUsersInRole != null && mappedUsersInRole.containsKey((String)ar.get('userId')))
			{
				userSummaryMap.put((String)ar.get('userId'), ar);
				summary.setCountAndAverage((Decimal)ar.get('totalCount'));
	            ReportDataRow userRdr = this.filteredOppDollarData.get((String)ar.get('userId'));
	            if(userRdr!=NULL) 
	            {
	            	userRdr.setCountAndAverage((Decimal)ar.get('totalCount'));
	            }
			}
        }
        
        if(opps.size() > 0)
        { 
            for(F2S_Opportunity_Snapshot__c opp : opps) 
            {
                if(mappedUsersInRole != null && mappedUsersInRole.containsKey(opp.User_ID__c))
                {
                    if(isUserLowestNode && opp.User_ID__c != UserInfo.getUserId().left(15))
                        continue;
                                            
                    ReportDataRow userRdr = this.filteredOppDollarData.get(opp.User_ID__c);
                    if(userRdr != null)
                    { 
						if(opp.Date__c >= previous4Weeks && opp.Date__c < currentWeekStart) 
                        {
                            userRdr.weekSummaryMetric4 += (opp.Est_Sales__c * 0.25);
                            summary.weekSummaryMetric4 += (opp.Est_Sales__c * 0.25);
                        }
                        if(opp.Date__c >= previous4Weeks && opp.Date__c < previous3Weeks) 
                        {
                            userRdr.weekPreviousValue4 += opp.Est_Sales__c;
                            summary.weekPreviousValue4 += opp.Est_Sales__c;
                        }
                        else if(opp.Date__c >= previous3Weeks && opp.Date__c < previous2Weeks) 
                        {
                            userRdr.weekPreviousValue3 += opp.Est_Sales__c;
                            summary.weekPreviousValue3 += opp.Est_Sales__c;
                        }
                        else if(opp.Date__c >= previous2Weeks && opp.Date__c < previous1Weeks) 
                        {
                            userRdr.weekPreviousValue2 += opp.Est_Sales__c;
                            summary.weekPreviousValue2 += opp.Est_Sales__c;
                        }
                        else if(opp.Date__c >= previous1Weeks && opp.Date__c < currentWeekStart) 
                        {
                            userRdr.weekPreviousValue1 += opp.Est_Sales__c;
                            summary.weekPreviousValue1 += opp.Est_Sales__c;
                        }
                    }
                }
            }
            summary.userCount = allUsersInRole.size();
            
            if(summary.userCount>0)
            {
                summary.calculateAverages();
            }
            summaryRowMap.put('oppDollars', summary);
        }
    }
 
    private void getCppCountData(String selectedRoleId) 
    {
        summaryRowMap.put('cppCounts', new ReportDataRow());
        //first get the set of role ids, beneath and including the current role:
        Set<String> filteredRoleIds = getFilteredSubRoleIds(new Set<String>{selectedRoleId.left(15)}); 
        filteredRoleIds.add(String.valueOf(currentRole.Id).left(15));
		List<User> usersFromRoles = this.getUsersByRole(filteredRoleIds);
		Map<String,User> mappedUsersInRole = new Map<String,User>();
		for(User u: usersFromRoles)
			mappedUsersInRole.put(String.valueOf(u.Id).left(15),u);
        List<F2S_CPP_Snapshot__c > cpps = [
                                                    SELECT Id, User_ID__c, Role_ID__c, Count__c, Date__c 
                                                    FROM F2S_CPP_Snapshot__c  
                                                    //WHERE Role_ID__c in :filteredRoleIds 
													WHERE User_ID__c IN: mappedUsersInRole.keySet()
                                                    AND Date__c >= :previous4Weeks
                                                    AND Date__c < :currentWeekStart
                                                    AND Role_ID__c != null 
                                                    AND User_ID__c != null
                                                    AND Date__c != null
                                                    AND Count__c != null
                                                    ORDER BY User_ID__c 
                                                ];
        
        //Now we have everything, sort by RoleId and create some lists, this will make subsequent calls easier
        Boolean isUserLowestNode = getIsUserLowestNode();
        Set<String> roleIds = getFilteredSubRoleIds(new Set<String>{String.valueOf(this.selectedRoleId)});
     
        //Reinitialize
        this.filteredCppData = new Map<Id, ReportDataRow>();
        this.filteredCppDataList = new List<ReportDataRow>();
        roleIds.add(this.selectedRoleId);
        //match the roles to the users here, pass in role ids, returns a list of filtered users based on currently selected hierarchy.
        ReportDataRow summary = new ReportDataRow();
        List<User> allUsersInRole = usersFromRoles;//getUsersByRole(roleIds);
        /*Map<String,User> mappedUsersInRole = new Map<String,User>();
        for(User u: allUsersInRole)
        {
            mappedUsersInRole.put(String.valueOf(u.Id).left(15),u);
        }*/
        //Always add a row for the current user
        if(isUserLowestNode)
        {
            ReportDataRow rdr = new ReportDataRow();
            rdr.userName = UserInfo.getName();
            this.filteredCppData.put(UserInfo.getUserId(), rdr);
            this.filteredCppDataList.add(rdr); 
        }
        else
        {
            if(allUsersInRole.size() > 0)
            {
                if(mappedUsersInRole != null)
                {
                    for(User u : allUsersInRole)
                    {
                        ReportDataRow rdr = new ReportDataRow();
                        rdr.userName = u.Name;
                        this.filteredCppData.put(u.Id, rdr);
                        this.filteredCppDataList.add(rdr); 
                    }
                }
            }
        } 
        
        AggregateResult[] userSummaryResult  = [SELECT User_ID__c userId, SUM(Count__c) totalCount
                                                FROM F2S_CPP_Snapshot__c 
                                                    //WHERE Role_ID__c in :filteredRoleIds 
                                                    WHERE User_ID__c IN: mappedUsersInRole.keySet()
														AND Date__c >= :last26Weeks
                                                    	AND Date__c < :currentWeekStart
                                                    	AND Role_ID__c != null 
											            AND User_ID__c != null
											            AND Date__c != null 
                                                    		GROUP BY User_ID__c];
                                                    		
        Map<String, AggregateResult> userSummaryMap = new Map<String, AggregateResult>();
        for(AggregateResult ar : userSummaryResult) {
			if(mappedUsersInRole != null && mappedUsersInRole.containsKey((String)ar.get('userId')))
			{
				userSummaryMap.put((String)ar.get('userId'), ar);
				summary.setCountAndAverage((Decimal)ar.get('totalCount'));
	            ReportDataRow userRdr = this.filteredCppData.get((String)ar.get('userId'));
	            if(userRdr!=NULL) 
	            {
	            	userRdr.setCountAndAverage((Decimal)ar.get('totalCount'));
	            }
			}
        }
        
        if(cpps.size() > 0)
        {
            for(F2S_CPP_Snapshot__c cpp : cpps) 
            {
                if(mappedUsersInRole != null && mappedUsersInRole.containsKey(cpp.User_ID__c))
                {
                    if(isUserLowestNode && cpp.User_ID__c != UserInfo.getUserId().left(15))
                        continue;
                                            
                    ReportDataRow userRdr = this.filteredCppData.get(cpp.User_ID__c);
                    if(userRdr != null)
                    { 
						if(cpp.Date__c >= previous4Weeks && cpp.Date__c < currentWeekStart) 
                        {
                            userRdr.weekSummaryMetric4 += (cpp.Count__c * 0.25);
                            summary.weekSummaryMetric4 += (cpp.Count__c * 0.25);
                        }
                        if(cpp.Date__c >= previous4Weeks && cpp.Date__c < previous3Weeks) 
                        {
                            userRdr.weekPreviousValue4 += cpp.Count__c;
                            summary.weekPreviousValue4 += cpp.Count__c;
                        }
                        else if(cpp.Date__c >= previous3Weeks && cpp.Date__c < previous2Weeks) 
                        {
                            userRdr.weekPreviousValue3 += cpp.Count__c;
                            summary.weekPreviousValue3 += cpp.Count__c;
                        }
                        else if(cpp.Date__c >= previous2Weeks && cpp.Date__c < previous1Weeks) 
                        {
                            userRdr.weekPreviousValue2 += cpp.Count__c;
                            summary.weekPreviousValue2 += cpp.Count__c;
                        }
                        else if(cpp.Date__c >= previous1Weeks && cpp.Date__c < currentWeekStart) 
                        {
                            userRdr.weekPreviousValue1 += cpp.Count__c;
                            summary.weekPreviousValue1 += cpp.Count__c;
                        }
                    }
                }
            }
            summary.userCount = allUsersInRole.size();
            
            if(summary.userCount>0)
            {
                summary.calculateAverages();
            }
            summaryRowMap.put('cppCounts', summary);
        }
    }
    
    private void getAccountPrioritizationData(String selectedRoleId) 
    {
        Boolean isUserLowestNode = getIsUserLowestNode();
        List<User> users = new List<User>();
        if(isUserLowestNode) 
        {
            users.add([SELECT Id, Name FROM User WHERE Id= :Userinfo.getUserId()][0]);  
        }
        else 
        {
            Set<String> roleIds = getFilteredSubRoleIds(new Set<String>{String.valueOf(this.selectedRoleId)}); 
            roleIds.add(String.valueOf(currentRole.Id).left(15));
            users = getUsersByRole(roleIds);    
        }
        
        AggregateResult[] groupedResults  = [SELECT Account.MarketingSegment__c F2SId, Count(Id) OppCount, Sum(Amount) OppAmount 
                                                FROM Opportunity 
                                                    WHERE Account.MarketingSegment__c != null
                                                        AND IsClosed = false
                                                        AND OwnerId in :users
                                                    Group By Account.MarketingSegment__c];
        Decimal oppSalesTotal = 0.00;
        Integer oppCountTotal = 0;
        accountPriorityMap.clear();
        accountPriorityList.clear();
        AccountPriority ep = new AccountPriority();
        ep.name = 'Estimated Potential';
        accountPriorityMap.put(ep.name, ep);
        for (AggregateResult ar : groupedResults)  
        {
            AccountPriority ap = new AccountPriority();
            ap.estimatedPotential = (Decimal) ar.get('OppAmount'); 
            ap.oppCount = (Integer) ar.get('OppCount');
            ap.name = String.valueOf(ar.get('F2SId'));
            accountPriorityMap.put(ap.name, ap);
            accountPriorityMap.get('Estimated Potential').estimatedPotential += ap.estimatedPotential;
            accountPriorityMap.get('Estimated Potential').oppCount += ap.oppCount; 
        }
        accountPriorityList.add(accountPriorityMap.get('Estimated Potential'));
        if(accountPriorityMap.get('Prospect')!=NULL) accountPriorityList.add(accountPriorityMap.get('Prospect'));
        if(accountPriorityMap.get('Lost')!=NULL) accountPriorityList.add(accountPriorityMap.get('Lost'));
        if(accountPriorityMap.get('Wounded')!=NULL) accountPriorityList.add(accountPriorityMap.get('Wounded'));
        if(accountPriorityMap.get('SOW')!=NULL) accountPriorityList.add(accountPriorityMap.get('SOW'));
    }
  
   private void getCppLbsData(String selectedRoleId) 
    {
        summaryRowMap.put('cppLbs', new ReportDataRow());
        //first get the set of role ids, beneath and including the current role:
        Set<String> filteredRoleIds = getFilteredSubRoleIds(new Set<String>{selectedRoleId.left(15)}); 
        filteredRoleIds.add(String.valueOf(currentRole.Id).left(15));
		List<User> usersFromRoles = this.getUsersByRole(filteredRoleIds);
		Map<String,User> mappedUsersInRole = new Map<String,User>();
		for(User u: usersFromRoles)
			mappedUsersInRole.put(String.valueOf(u.Id).left(15),u);
        List<F2S_CPP_Snapshot__c > cpps = [
                                                    SELECT Id, User_ID__c, Role_ID__c, Total_Annual_Lbs__c, Date__c 
                                                    FROM F2S_CPP_Snapshot__c
                                                    //WHERE Role_ID__c in :filteredRoleIds 
													WHERE User_ID__c IN: mappedUsersInRole.keySet()
                                                    AND Date__c >= :previous4Weeks
                                                    AND Date__c < :currentWeekStart
                                                    AND Role_ID__c != null 
                                                    AND User_ID__c != null
                                                    AND Date__c != null
                                                    AND Total_Annual_Lbs__c != null
                                                    ORDER BY User_ID__c 
                                                ];
        
        //Now we have everything, sort by RoleId and create some lists, this will make subsequent calls easier
        Boolean isUserLowestNode = getIsUserLowestNode();
        Set<String> roleIds = getFilteredSubRoleIds(new Set<String>{String.valueOf(this.selectedRoleId)});
     
        //Reinitialize
        this.filteredCppLbsData = new Map<Id, ReportDataRow>();
        this.filteredCppLbsDataList = new List<ReportDataRow>();
        roleIds.add(this.selectedRoleId);
        //match the roles to the users here, pass in role ids, returns a list of filtered users based on currently selected hierarchy.
        ReportDataRow summary = new ReportDataRow();
        List<User> allUsersInRole = usersFromRoles;//getUsersByRole(roleIds);
        /*Map<String,User> mappedUsersInRole = new Map<String,User>();
        for(User u: allUsersInRole)
        {
            mappedUsersInRole.put(String.valueOf(u.Id).left(15),u);
        }*/
        //Always add a row for the current user
        if(isUserLowestNode)
        {
            ReportDataRow rdr = new ReportDataRow();
            rdr.userName = UserInfo.getName();
            this.filteredCppLbsData.put(UserInfo.getUserId(), rdr); 
            this.filteredCppLbsDataList.add(rdr);
        }
        else
        {
            if(allUsersInRole.size() > 0)
            {
                if(mappedUsersInRole != null)
                {
                    for(User u : allUsersInRole)
                    {
                        ReportDataRow rdr = new ReportDataRow();
                        rdr.userName = u.Name;
                        this.filteredCppLbsData.put(u.Id, rdr);
                        this.filteredCppLbsDataList.add(rdr); 
                    }
                }
            }
        }
        
        AggregateResult[] userSummaryResult  = [SELECT User_ID__c userId, SUM(Total_Annual_Lbs__c) totalCount
                                                FROM F2S_CPP_Snapshot__c 
                                                    //WHERE Role_ID__c in :filteredRoleIds 
                                                    WHERE User_ID__c IN: mappedUsersInRole.keySet()
														AND Date__c >= :last26Weeks
                                                    	AND Date__c < :currentWeekStart
                                                    	AND Role_ID__c != null 
											            AND User_ID__c != null
											            AND Date__c != null 
                                                    		GROUP BY User_ID__c];
                                                    		
        Map<String, AggregateResult> userSummaryMap = new Map<String, AggregateResult>();
        for(AggregateResult ar : userSummaryResult) {
			if(mappedUsersInRole != null && mappedUsersInRole.containsKey((String)ar.get('userId')))
			{
				userSummaryMap.put((String)ar.get('userId'), ar);
				summary.setCountAndAverage((Decimal)ar.get('totalCount'));
	            ReportDataRow userRdr = this.filteredCppLbsData.get((String)ar.get('userId'));
	            if(userRdr!=NULL) 
	            {
	            	userRdr.setCountAndAverage((Decimal)ar.get('totalCount'));
	            }
			}
        }
        
        if(cpps.size() > 0)
        { 
            for(F2S_CPP_Snapshot__c cpp : cpps) 
            {
                if(mappedUsersInRole != null && mappedUsersInRole.containsKey(cpp.User_ID__c))
                {
                    if(isUserLowestNode && cpp.User_ID__c != UserInfo.getUserId().left(15))
                        continue;
                                            
                    ReportDataRow userRdr = this.filteredCppLbsData.get(cpp.User_ID__c);
                    if(userRdr != null)
                    { 
						if(cpp.Date__c >= previous4Weeks && cpp.Date__c < currentWeekStart) 
                        {
                            userRdr.weekSummaryMetric4 += (cpp.Total_Annual_Lbs__c * 0.25);
                            summary.weekSummaryMetric4 += (cpp.Total_Annual_Lbs__c * 0.25);
                        }
                        if(cpp.Date__c >= previous4Weeks && cpp.Date__c < previous3Weeks) 
                        {
                            userRdr.weekPreviousValue4 += cpp.Total_Annual_Lbs__c;
                            summary.weekPreviousValue4 += cpp.Total_Annual_Lbs__c;
                        }
                        else if(cpp.Date__c >= previous3Weeks && cpp.Date__c < previous2Weeks) 
                        {
                            userRdr.weekPreviousValue3 += cpp.Total_Annual_Lbs__c;
                            summary.weekPreviousValue3 += cpp.Total_Annual_Lbs__c;
                        }
                        else if(cpp.Date__c >= previous2Weeks && cpp.Date__c < previous1Weeks) 
                        {
                            userRdr.weekPreviousValue2 += cpp.Total_Annual_Lbs__c;
                            summary.weekPreviousValue2 += cpp.Total_Annual_Lbs__c;
                        }
                        else if(cpp.Date__c >= previous1Weeks && cpp.Date__c < currentWeekStart) 
                        {
                            userRdr.weekPreviousValue1 += cpp.Total_Annual_Lbs__c;
                            summary.weekPreviousValue1 += cpp.Total_Annual_Lbs__c;
                        }
                    }
                }
            }
            summary.userCount = allUsersInRole.size();
            
            if(summary.userCount>0)
            {
                summary.calculateAverages();
            }
            summaryRowMap.put('cppLbs', summary);
        }
    }
	
	// NEW ///////////////////
	private void getOppWonData(String selectedRoleId) 
    {
		summaryRowMap.put('oppsWon', new ReportDataRow());
        //first get the set of role ids, beneath and including the current role:
        Set<String> filteredRoleIds = getFilteredSubRoleIds(new Set<String>{selectedRoleId.left(15)}); 
        filteredRoleIds.add(String.valueOf(currentRole.Id).left(15));
		List<User> usersFromRoles = this.getUsersByRole(filteredRoleIds);
		Map<String,User> mappedUsersInRole = new Map<String,User>();
		for(User u: usersFromRoles)
			mappedUsersInRole.put(String.valueOf(u.Id).left(15),u);
        List<F2S_Opportunity_Snapshot__c> opps = [
                                                    SELECT Id, User_ID__c, Role_ID__c, Count__c, Date__c, Stage__c 
                                                    FROM F2S_Opportunity_Snapshot__c 
                                                    //WHERE Role_ID__c in :filteredRoleIds 
													WHERE User_ID__c IN: mappedUsersInRole.keySet()
                                                    AND Date__c >= :previous4Weeks
                                                    AND Date__c < :currentWeekStart
                                                    AND Role_ID__c != null 
                                                    AND User_ID__c != null
                                                    AND Date__c != null
                                                    AND Count__c != null
													AND Stage__c != null
													AND Stage__c = 'Closed Won'
                                                    ORDER BY User_ID__c 
                                                ];
        
        //Now we have everything, sort by RoleId and create some lists, this will make subsequent calls easier
        Boolean isUserLowestNode = getIsUserLowestNode();
        Set<String> roleIds = getFilteredSubRoleIds(new Set<String>{String.valueOf(this.selectedRoleId)});
     
        //Reinitialize
        this.filteredOppClosedWonData = new Map<Id, ReportDataRow>();
        this.filteredOppClosedWonList = new List<ReportDataRow>();
        roleIds.add(this.selectedRoleId);
        //match the roles to the users here, pass in role ids, returns a list of filtered users based on currently selected hierarchy.

        ReportDataRow summary = new ReportDataRow();
        List<User> allUsersInRole = usersFromRoles;//getUsersByRole(roleIds);
        /*Map<String,User> mappedUsersInRole = new Map<String,User>();
        for(User u: allUsersInRole)
        {
            mappedUsersInRole.put(String.valueOf(u.Id).left(15),u);
        }*/
        //Always add a row for the current user
        if(isUserLowestNode)
        {
            ReportDataRow rdr = new ReportDataRow();
            rdr.userName = UserInfo.getName();
            this.filteredOppClosedWonData.put(UserInfo.getUserId(), rdr); 
            this.filteredOppClosedWonList.add(rdr);
        }
        else
        {
            if(allUsersInRole.size() > 0)
            {
                if(mappedUsersInRole != null)
                {
                    for(User u : allUsersInRole)
                    {
                        ReportDataRow rdr = new ReportDataRow();
                        rdr.userName = u.Name;
                        this.filteredOppClosedWonData.put(u.Id, rdr);
                        this.filteredOppClosedWonList.add(rdr); 
                    }
                }
            }
        } 
        
        AggregateResult[] userSummaryResult  = [SELECT User_ID__c userId, SUM(Count__c) totalCount
                                                FROM F2S_Opportunity_Snapshot__c 
                                                    //WHERE Role_ID__c in :filteredRoleIds 
                                                    WHERE User_ID__c IN: mappedUsersInRole.keySet()
														AND Date__c >= :last26Weeks
                                                    	AND Date__c < :currentWeekStart
                                                    	AND Role_ID__c != null 
											            AND User_ID__c != null
											            AND Date__c != null 
														AND Stage__c != null 
														AND Stage__c = 'Closed Won'
                                                    		GROUP BY User_ID__c];
        Map<String, AggregateResult> userSummaryMap = new Map<String, AggregateResult>();
        for(AggregateResult ar : userSummaryResult) {
        	if(mappedUsersInRole != null && mappedUsersInRole.containsKey((String)ar.get('userId')))
			{
				userSummaryMap.put((String)ar.get('userId'), ar);
				summary.setCountAndAverage((Decimal)ar.get('totalCount'));
	            ReportDataRow userRdr = this.filteredOppClosedWonData.get((String)ar.get('userId'));
	            if(userRdr!=NULL) 
	            {
	            	userRdr.setCountAndAverage((Decimal)ar.get('totalCount'));
	            }
			}
        }
        
        if(opps.size() > 0)
        {
            for(F2S_Opportunity_Snapshot__c opp : opps) 
            {
                if(mappedUsersInRole != null && mappedUsersInRole.containsKey(opp.User_ID__c))
                {
                    if(isUserLowestNode && opp.User_ID__c != UserInfo.getUserId().left(15))
                        continue;
                                            
                    ReportDataRow userRdr = this.filteredOppClosedWonData.get(opp.User_ID__c);
                    if(userRdr != null)
                    { 
						if(opp.Date__c >= previous4Weeks && opp.Date__c < currentWeekStart) 
                        {
                            userRdr.weekSummaryMetric4 += (opp.Count__c * 0.25);
                            summary.weekSummaryMetric4 += (opp.Count__c * 0.25);
                        }
                        if(opp.Date__c >= previous4Weeks && opp.Date__c < previous3Weeks) 
                        {
                            userRdr.weekPreviousValue4 += opp.Count__c;
                            summary.weekPreviousValue4 += opp.Count__c;
                        }
                        else if(opp.Date__c >= previous3Weeks && opp.Date__c < previous2Weeks) 
                        {
                            userRdr.weekPreviousValue3 += opp.Count__c;
                            summary.weekPreviousValue3 += opp.Count__c;
                        }
                        else if(opp.Date__c >= previous2Weeks && opp.Date__c < previous1Weeks) 
                        {
                            userRdr.weekPreviousValue2 += opp.Count__c;
                            summary.weekPreviousValue2 += opp.Count__c;
                        }
                        else if(opp.Date__c >= previous1Weeks && opp.Date__c < currentWeekStart) 
                        {
                            userRdr.weekPreviousValue1 += opp.Count__c;
                            summary.weekPreviousValue1 += opp.Count__c;
                        }
                    }
                }
            }
            summary.userCount = allUsersInRole.size();
            
            if(summary.userCount>0)
            {
                summary.calculateAverages();
            }
            summaryRowMap.put('oppsWon', summary);
        }
    }
	
	private void getOppWonDollarsData(String selectedRoleId) 
    {
	    summaryRowMap.put('oppsWonDollars', new ReportDataRow());
        //first get the set of role ids, beneath and including the current role:
        Set<String> filteredRoleIds = getFilteredSubRoleIds(new Set<String>{selectedRoleId.left(15)}); 
        filteredRoleIds.add(String.valueOf(currentRole.Id).left(15));
		List<User> usersFromRoles = this.getUsersByRole(filteredRoleIds);
		Map<String,User> mappedUsersInRole = new Map<String,User>();
		for(User u: usersFromRoles)
			mappedUsersInRole.put(String.valueOf(u.Id).left(15),u);
        List<F2S_Opportunity_Snapshot__c> opps = [
                                                    SELECT Id, User_ID__c, Role_ID__c, Est_Sales__c, Date__c, Stage__c 
                                                    FROM F2S_Opportunity_Snapshot__c 
                                                    //WHERE Role_ID__c in :filteredRoleIds 
													WHERE User_ID__c IN: mappedUsersInRole.keySet()
                                                    AND Date__c >= :previous4Weeks
                                                    AND Date__c < :currentWeekStart
                                                    AND Role_ID__c != null 
                                                    AND User_ID__c != null
                                                    AND Date__c != null
                                                    AND Est_Sales__c != null
													AND Stage__c != null
													AND Stage__c = 'Closed Won'
                                                    ORDER BY User_ID__c 
                                                ];
        
        //Now we have everything, sort by RoleId and create some lists, this will make subsequent calls easier
       
        Boolean isUserLowestNode = getIsUserLowestNode();
        Set<String> roleIds = getFilteredSubRoleIds(new Set<String>{String.valueOf(this.selectedRoleId)});
     
        //Reinitialize
        this.filteredOppClosedWonDollarData = new Map<Id, ReportDataRow>();
        this.filteredOppClosedWonDollarList = new List<ReportDataRow>();
        roleIds.add(this.selectedRoleId);
        //match the roles to the users here, pass in role ids, returns a list of filtered users based on currently selected hierarchy.
        ReportDataRow summary = new ReportDataRow();
        List<User> allUsersInRole = usersFromRoles;//getUsersByRole(roleIds);
        /*Map<String,User> mappedUsersInRole = new Map<String,User>();
        for(User u: allUsersInRole)
        {
            mappedUsersInRole.put(String.valueOf(u.Id).left(15),u);
        }*/
        //Always add a row for the current user
        if(isUserLowestNode)
        {
            ReportDataRow rdr = new ReportDataRow();
            rdr.userName = UserInfo.getName();
            this.filteredOppClosedWonDollarData.put(UserInfo.getUserId(), rdr); 
            this.filteredOppClosedWonDollarList.add(rdr);
        }
        else
        {
            if(allUsersInRole.size() > 0)
            {
                if(mappedUsersInRole != null)
                {
                    for(User u : allUsersInRole)
                    {
                        ReportDataRow rdr = new ReportDataRow();
                        rdr.userName = u.Name;
                        this.filteredOppClosedWonDollarData.put(u.Id, rdr);
                        this.filteredOppClosedWonDollarList.add(rdr); 
                    }
                }
            }
        }
        
        AggregateResult[] userSummaryResult  = [SELECT User_ID__c userId, SUM(Est_Sales__c) totalCount
                                                FROM F2S_Opportunity_Snapshot__c 
                                                    //WHERE Role_ID__c in :filteredRoleIds 
                                                    WHERE User_ID__c IN: mappedUsersInRole.keySet()
														AND Date__c >= :last26Weeks
                                                    	AND Date__c < :currentWeekStart
                                                    	AND Role_ID__c != null 
											            AND User_ID__c != null
											            AND Date__c != null
											            AND Est_Sales__c != null
														AND Stage__c != null 
														AND Stage__c = 'Closed Won'
                                                    		GROUP BY User_ID__c];
        Map<String, AggregateResult> userSummaryMap = new Map<String, AggregateResult>();
        for(AggregateResult ar : userSummaryResult) {
			if(mappedUsersInRole != null && mappedUsersInRole.containsKey((String)ar.get('userId')))
			{
				userSummaryMap.put((String)ar.get('userId'), ar);
				summary.setCountAndAverage((Decimal)ar.get('totalCount'));
	            ReportDataRow userRdr = this.filteredOppClosedWonDollarData.get((String)ar.get('userId'));
	            if(userRdr!=NULL) 
	            {
	            	userRdr.setCountAndAverage((Decimal)ar.get('totalCount'));
	            }
			}
        }
        
        if(opps.size() > 0)
        { 
            for(F2S_Opportunity_Snapshot__c opp : opps) 
            {
                if(mappedUsersInRole != null && mappedUsersInRole.containsKey(opp.User_ID__c))
                {
                    if(isUserLowestNode && opp.User_ID__c != UserInfo.getUserId().left(15))
                        continue;
                                            
                    ReportDataRow userRdr = this.filteredOppClosedWonDollarData.get(opp.User_ID__c);
                    if(userRdr != null)
                    { 
						if(opp.Date__c >= previous4Weeks && opp.Date__c < currentWeekStart) 
                        {
                            userRdr.weekSummaryMetric4 += (opp.Est_Sales__c * 0.25);
                            summary.weekSummaryMetric4 += (opp.Est_Sales__c * 0.25);
                        }
                        if(opp.Date__c >= previous4Weeks && opp.Date__c < previous3Weeks) 
                        {
                            userRdr.weekPreviousValue4 += opp.Est_Sales__c;
                            summary.weekPreviousValue4 += opp.Est_Sales__c;
                        }
                        else if(opp.Date__c >= previous3Weeks && opp.Date__c < previous2Weeks) 
                        {
                            userRdr.weekPreviousValue3 += opp.Est_Sales__c;
                            summary.weekPreviousValue3 += opp.Est_Sales__c;
                        }
                        else if(opp.Date__c >= previous2Weeks && opp.Date__c < previous1Weeks) 
                        {
                            userRdr.weekPreviousValue2 += opp.Est_Sales__c;
                            summary.weekPreviousValue2 += opp.Est_Sales__c;
                        }
                        else if(opp.Date__c >= previous1Weeks && opp.Date__c < currentWeekStart) 
                        {
                            userRdr.weekPreviousValue1 += opp.Est_Sales__c;
                            summary.weekPreviousValue1 += opp.Est_Sales__c;
                        }
                    }
                }
            }
            summary.userCount = allUsersInRole.size();
            
            if(summary.userCount>0)
            {
                summary.calculateAverages();
            }
            summaryRowMap.put('oppsWonDollars', summary);
        }
    }
	// END NEW ///////////////////  
    
    public void calculateTargetSummaryPercentages(ReportDataRow targetSummary, ReportDataRow summary)
    {
        //Change the target summary rows to percentages of the summary rows
        targetSummary.weekSummaryMetric26 = summary.weekSummaryMetric26 !=0 ? (targetSummary.weekSummaryMetric26 / summary.weekSummaryMetric26) * 100 : 0 ;
		targetSummary.weekSummaryMetric4 = summary.weekSummaryMetric4 !=0 ? (targetSummary.weekSummaryMetric4 / summary.weekSummaryMetric4) * 100 : 0 ;
        targetSummary.weekPreviousValue4SummaryMetric = summary.weekPreviousValue4SummaryMetric !=0 ? (targetSummary.weekPreviousValue4SummaryMetric / summary.weekPreviousValue4SummaryMetric) * 100 : 0 ;
        targetSummary.weekPreviousValue3SummaryMetric = summary.weekPreviousValue3SummaryMetric !=0 ? (targetSummary.weekPreviousValue3SummaryMetric / summary.weekPreviousValue3SummaryMetric) * 100 : 0 ;
        targetSummary.weekPreviousValue2SummaryMetric = summary.weekPreviousValue2SummaryMetric !=0 ? (targetSummary.weekPreviousValue2SummaryMetric / summary.weekPreviousValue2SummaryMetric) * 100 : 0 ;
        targetSummary.weekPreviousValue1SummaryMetric = summary.weekPreviousValue1SummaryMetric !=0 ? (targetSummary.weekPreviousValue1SummaryMetric / summary.weekPreviousValue1SummaryMetric) * 100 : 0 ;
    }
    
    /*
        This class is used for Account Prioritization Data
    */
    public class AccountPriority
    {
        public Decimal estimatedPotential {get; set;}
        public Integer oppCount {get; set;}
        public String name {get; set;}
        
        public AccountPriority() {
            this.estimatedPotential = 0.00;
            this.oppCount = 0;
        }
    }
    
    /* 
        This class is used for Row Data
    */
    public class ReportDataRow 
    {
        public String userName {get; set;}
        public Integer userCount {get; set;}
        public Decimal totalCount {get; set;}
        public Decimal weekSummaryMetric26 {get; set;}
        public Decimal weekSummaryMetric26Total {get; set;}
		// new enhancement
        public Decimal weekSummaryMetric4 {get; set;}
        public Decimal weekSummaryMetric4Total {get; set;}
		// end new enhancement
        public Decimal weekPreviousValue4 {get; set;}
        public Decimal weekPreviousValue3 {get; set;}
        public Decimal weekPreviousValue2 {get; set;}
        public Decimal weekPreviousValue1 {get; set;}
        public Decimal weekCurrentValue {get; set;}
        public Decimal weekNextValue {get; set;}
        //The summary metrics store Averages or percentages, depending upon the context of the row.
        public Decimal totalSummaryMetric {get; set;}
        public Decimal weekPreviousValue4SummaryMetric {get; set;}
        public Decimal weekPreviousValue3SummaryMetric {get; set;}
        public Decimal weekPreviousValue2SummaryMetric {get; set;}
        public Decimal weekPreviousValue1SummaryMetric {get; set;}
        public Decimal weekCurrentValueSummaryMetric {get; set;}
        public Decimal weekNextValueSummaryMetric {get; set;}        
        
        public ReportDataRow() 
        {
            this.totalCount = 0.00;
            this.totalSummaryMetric = 0.00;
            this.userCount = 0;
            this.weekSummaryMetric26 = 0.00;
            this.weekPreviousValue4 = 0; 
            this.weekPreviousValue3 = 0;
            this.weekPreviousValue2 = 0;
            this.weekPreviousValue1 = 0;
            this.weekCurrentValue = 0;
            this.weekNextValue = 0;
            this.weekPreviousValue4SummaryMetric = 0; 
            this.weekPreviousValue3SummaryMetric = 0;
            this.weekPreviousValue2SummaryMetric = 0;
            this.weekPreviousValue1SummaryMetric = 0;
            this.weekCurrentValueSummaryMetric = 0;
            this.weekNextValueSummaryMetric = 0;
			// new enhancement
        	this.weekSummaryMetric4 = 0;
			// end new enhancement
        }
        
        public void setCountAndAverage(Decimal count) 
        {
            this.totalCount += count;
            this.weekSummaryMetric26 = this.totalCount/26.00;
            this.weekSummaryMetric26 = this.weekSummaryMetric26.setScale(2, RoundingMode.HALF_UP);
        }
               
        public void calculateAverages() 
        {
            this.weekSummaryMetric26Total = this.weekSummaryMetric26;
            this.weekSummaryMetric26 = this.weekSummaryMetric26/this.userCount;
            this.weekPreviousValue4SummaryMetric = this.weekPreviousValue4/this.userCount;
            this.weekPreviousValue3SummaryMetric = this.weekPreviousValue3/this.userCount;
            this.weekPreviousValue2SummaryMetric = this.weekPreviousValue2/this.userCount;
            this.weekPreviousValue1SummaryMetric = this.weekPreviousValue1/this.userCount;
            this.weekSummaryMetric4Total = (this.weekPreviousValue4 + this.weekPreviousValue3 + this.weekPreviousValue2 + this.weekPreviousValue1) / 4;
			this.weekSummaryMetric4Total = this.weekSummaryMetric4Total.setScale(2, RoundingMode.HALF_UP);
			this.weekCurrentValueSummaryMetric = this.weekCurrentValue/this.userCount;
            this.weekNextValueSummaryMetric = this.weekNextValue/this.userCount;            
        }
    }   
     
    public PageReference refreshCallData() 
    {
		bRenderHyperLinks = false;
        childRoleHierarchy = roleHierarchy.get(this.selectedRoleId);
        currentRole = roleMap.get(this.selectedRoleId);
        getCallsData(this.selectedRoleId);
        return null;
    }
    
    public PageReference refreshOpportunityCountData() 
    {
		bRenderHyperLinks = false;
        childRoleHierarchy = roleHierarchy.get(this.selectedRoleId);
        currentRole = roleMap.get(this.selectedRoleId);
        getOppCountData(this.selectedRoleId);
        return null;
    } 
    
    public PageReference refreshOpportunityDollarData() 
    {
		bRenderHyperLinks = false;
        childRoleHierarchy = roleHierarchy.get(this.selectedRoleId);
        currentRole = roleMap.get(this.selectedRoleId);
        getOppDollarData(this.selectedRoleId);
        return null;
    }
    
    public PageReference refreshCppCountData() 
    {
		bRenderHyperLinks = false;
        childRoleHierarchy = roleHierarchy.get(this.selectedRoleId);
        currentRole = roleMap.get(this.selectedRoleId);
        getCppCountData(this.selectedRoleId);
        return null;
    }
    
    public PageReference refreshCppLbsData() 
    {
		bRenderHyperLinks = false;
        childRoleHierarchy = roleHierarchy.get(this.selectedRoleId);
        currentRole = roleMap.get(this.selectedRoleId);
        getCppLbsData(this.selectedRoleId);
        return null;
    }
	
	// NEW /////
	public PageReference refreshOppsClosedWonData() 
    {
		bRenderHyperLinks = false;
		childRoleHierarchy = roleHierarchy.get(this.selectedRoleId);
        currentRole = roleMap.get(this.selectedRoleId);
        getOppWonData(this.selectedRoleId);
        return null;
    }
	
	public PageReference refreshOppsClosesWonDollarData()
	{
		bRenderHyperLinks = false;
		childRoleHierarchy = roleHierarchy.get(this.selectedRoleId);
        currentRole = roleMap.get(this.selectedRoleId);
        getOppWonDollarsData(this.selectedRoleId);
        return null;
	}
	// END NEW ////
    
    public PageReference refreshAccountPrioritizationData() 
    {
		bRenderHyperLinks = false;
        childRoleHierarchy = roleHierarchy.get(this.selectedRoleId);
        currentRole = roleMap.get(this.selectedRoleId);
        getAccountPrioritizationData(this.selectedRoleId);
        return null;
    }
    
    public PageReference refreshDistrictSummary() {
        //dummy call to refresh the district summary after all calculations have updated
		bRenderHyperLinks = true;
		childRoleHierarchy = GetSortedChildHierarchy();
		//System.Debug('*** ' + summaryRowMap);
        return null;
    }
            
    private Set<ID> getAllSubRoleIds(Set<ID> roleIds) 
    {
        Set<ID> currentRoleIds = new Set<ID>();
     
        // get all of the roles underneath the passed roles
        for(UserRole userRole :[select Id from UserRole where ParentRoleId 
          IN :roleIds AND ParentRoleID != null])
        currentRoleIds.add(userRole.Id);
     
        if(currentRoleIds.size() > 0)
          currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
     
        return currentRoleIds;
    }
	
	private static List<String> customRoles = new List<String>{'Global Executives', 'US IC Executives', 'RVP', 'GM', 'DM', 'SM', 'Sales Rep', 'VP Roles', 'Strategic Accounts', 'International Trade'};
    // NEW
	public List<UserRole> GetSortedChildHierarchy()
	{
		List<UserRole> hierarchy = roleHierarchy.get(this.selectedRoleId) == null ? null : roleHierarchy.get(this.selectedRoleId).clone();
		List<UserRole> sortedList = new List<UserRole>();
		if(hierarchy == null || hierarchy.size() == 0)
			return sortedList;
		for(String s : customRoles)//sort roles based on list
		{
			List<Integer> indexFound = new List<Integer>();
			List<Boolean> bSave = new List<Boolean>();
			for(Integer i = 0; i < hierarchy.size(); i++)
			{
				UserRole u = hierarchy.get(i);
				if(u.Name.contains('Inactive Over 60 Days'))
				{
					indexFound.add(i);
					bSave.add(false);
				}
				else if(u.Name.contains(s))//if this userrole.name contains the role from above, add it to the new list
				{
					indexFound.add(i);
					bSave.add(true);
				}
			}
			for(Integer i = indexFound.size() - 1; i >= 0; i--)
			{
				UserRole u = hierarchy.remove(indexFound[i]);
				if(bSave[i])
					sortedList.add(u);
			}
		}
		//add the rest, in case some were missed
		sortedList.addAll(hierarchy);
		return sortedList;
	}
	// END NEW
	
    public void setRoleHierarchy(Id currentRoleId) {
        this.roleHierarchy = new Map<String, List<UserRole>>();
        this.roleMap = new Map<Id, UserRole>();
        Set<Id> allRoleIds = getAllSubRoleIds(new Set<Id>{currentRoleId});
        allRoleIds.add(currentRoleId);
        List<UserRole> userRoleList = [SELECT Id, Name, ParentRoleId FROM UserRole WHERE Id in:allRoleIds];
        for(UserRole ur:userRoleList) 
        {
            String parentRoleIdString = String.valueOf(ur.ParentRoleId).left(15);
            if(roleHierarchy.get(parentRoleIdString)==NULL) 
            {
                roleHierarchy.put(parentRoleIdString, new List<UserRole>());
            }
            roleHierarchy.get(parentRoleIdString).add(ur);
            roleMap.put(ur.Id, ur);
        }
    } 
}