Последовательность загрузки.
loadjava -user CRM_33_CHE/CRM_33_CHE@ORCL12 -resolve jackson-core-asl.jar

1. jackson-core-asl.jar
2. joda-time-2.3.jar
3. jackson-mapper-asl.jar
4. javax-inject.jar
5. paranamer-2.4.jar
6. snappy-java-1.0.3-rc2.jar
7. avro.jar
--8. db-4.7.25.jar
--9. ant-1.7.1-launcher.jar
--10. apache-ant-1.8.2.jar
--11. je.jar
12.kvclient.jar
loadjava -user CRM_33_CHE/CRM_33_CHE@ORCL12 -resolver "((* CRM_33_CHE) (* public) (* -))" -force -genmissing kvclient.jar