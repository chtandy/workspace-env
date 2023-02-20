### 創建有ssh 能力的container
- 只有/data有持久化，其餘目錄不會持久化，建立乾淨的測試作業環境
### 目的
- 可以用於管理多個k8s cluster 的環境
- 可以創建測試環境，重啟container後，家目錄也一併移除再重建


### 注意事項
- 可以選擇使用個人帳號或是使用root帳號
- 個人帳號已加入sudo user
- 若USERNAME, USER_ID 與UserAuthPubKey其中一個沒填，ROOT_PASSWD 有填，則登入使用root登入
- 登入順序為user > root 
- 若都沒填，則只能使用docker exec 方式進入
