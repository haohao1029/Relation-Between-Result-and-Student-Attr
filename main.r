#Name : Gan Jing Hao @ Kingsley
#TP: TP051098
rm(list=ls())

init <<- function() {
  initEnv <- function() {
    # package manager helps install and import package
    pacman::p_load(readr, pacman, ggplot2, gridExtra, dplyr, lubridate, climatol, plotrix, ggExtra, ggrepel)
  }
  importData <- function() {
    csv_file_url <- "https://leadinghao.com/wp-content/uploads/2021/08/student.csv"
    student <- read_delim(file=csv_file_url, delim = ";", quote = "")
    return(student)
  }
  
  formatStringData <- function(student) {
    tempcol = c()
    student_perf = data.frame(index = 1:nrow(student))
    
    # Replace all double quote by empty string
    for(col in 1:length(student)){
      tempcol = c()
      for(row in student[,col]){
        temp = gsub ("\"","", row)
        tempcol = c(tempcol,temp)
      }
      student_perf = cbind(student_perf, tempcol)
    }
    colname = c("index", names(student))
    names(student_perf) = colname
    return(student_perf)
  }
  
  formatDataType <- function() {
    dataset$Medu <<- as.numeric(dataset$Medu)
    dataset$Fedu <<- as.numeric(dataset$Fedu)
    dataset$traveltime <<- as.numeric(dataset$traveltime)
    dataset$studytime <<- as.numeric(dataset$studytime)
    dataset$failures <<- as.numeric(dataset$failures)
    dataset$famrel <<- as.numeric(dataset$famrel)
    dataset$freetime <<- as.numeric(dataset$freetime)
    dataset$goout <<- as.numeric(dataset$goout)
    dataset$Dalc <<- as.numeric(dataset$Dalc)
    dataset$Walc <<- as.numeric(dataset$Walc)
    dataset$health <<- as.numeric(dataset$health)
    dataset$absences <<- as.numeric(dataset$absences)
    dataset$G1 <<- as.numeric(dataset$G1)
    dataset$G2 <<- as.numeric(dataset$G2)
    dataset$G3 <<- as.numeric(dataset$G3)
  }
  
  initExtraCol <- function() {
    # Add Extra Column To Dataset
    dataset$Fedu_name <<- getFullName(dataset$Fedu)
    dataset$Medu_name <<- getFullName(dataset$Medu)
    dataset$AvgGrade <<- getAverangeResult(dataset$G1,dataset$G2,dataset$G3)
    dataset <<- dataset %>% mutate(G3Name = case_when (G3 <= 8 ~ "low", G3 >= 9 & G3 <= 14 ~ "medium", G3 < 21 ~ "high") )
    dataset <<- dataset %>% mutate(Pstatus = case_when (Pstatus == "T" ~ "Together", Pstatus == "A" ~ "Apart"))
  }
  getAverangeResult <- function(G1,G2,G3) {
      result <- round((G1 + G2 + G3) / 3, 2)
      return(result)
  }
  
  getFullName <- function(data) {
    columns = c("none", "primary education", "5th to 9th grade", "secondary education", "higher education")
    return(columns[data])
  }
  
  initGlobalVar <- function() {
    file_url <<- "/media/ubuntu/UBUNTU 20_0/PDFA/assignment/img" # absolute save path
  }

  initEnv()
  student <- importData()
  dataset <<- formatStringData(student)
  formatDataType()
  initExtraCol()
  initGlobalVar()
}

init()

# Q1 Parent Edu Level
parentEdu <- function(){
  
  edu_parent <- ggplot(dataset, aes(Fedu, Medu)) + ylab("Mother's Edu Level") + xlab("Father's Edu Level") + geom_count()
  
  graph = marrangeGrob(list(edu_parent), nrow = 1,ncol = 1,top = "Parents' Education Level") # marrageGrob Arrange Graph in Grid Views

ggsave(filename = paste("img/q3 - Parents Edu Level.png",sep=""),graph,dpi = 1000,width = 10,height = 5)

graph
}
parentEdu()

# Q2 Relation Between G3, school and Parents Edu Level
relR3AndParentAndSchool <- function() {
  
  relation_g3_father_school <- ggplot(dataset, aes(Fedu, G3)) + scale_colour_brewer() + labs(title="Relation between G3, Sch and Father' education level") +
    ylab("G3 Result") +
    xlab("Father's Edu Level") + geom_count() + stat_smooth(method = "lm") + facet_wrap(~school) # facet_wrap splits graph by school
  
  
  relation_g3_mother_school <- ggplot(dataset, aes(Medu, G3)) + scale_colour_brewer() + labs(title="Relation between G3, Sch and Mother' education level") +
    ylab("G3 Result") +
    xlab("Mother's Edu Level") + geom_count() + stat_smooth(method = "lm") + facet_wrap(~school)
  
  q3_relation_g3_parent_school = marrangeGrob(list(relation_g3_father_school, relation_g3_mother_school), nrow = 1,ncol = 2,top = "Relationship Between G3, Parent Edu Lvl and School")
  ggsave(filename = paste("img/Relation Between G3, school and Parents Edu Level.png",sep=""),q3_relation_g3_parent_school,dpi = 1000,width = 10,height = 5)
  q3_relation_g3_parent_school
}
relR3AndParentAndSchool()

# Q3 Relation Between G3, sex and Parents Edu Level
relR3AndParentAndSex <- function() {
  # G3 - father edu
  relation_g3_father_sex <- ggplot(dataset, aes(Fedu, G3)) + scale_colour_brewer() + labs(title="Relation between G3, Sch and Father' education level") +
    ylab("G3 Result") +
    xlab("Father's Edu Level") + geom_count() + stat_smooth(method = "lm") + facet_wrap(~sex)
  
  # G3 - mom edu
  relation_g3_mother_sex <- ggplot(dataset, aes(Medu, G3)) + scale_colour_brewer() + labs(title="Relation between G3, Sch and Mother' education level") +
    ylab("G3 Result") +
    xlab("Mother's Edu Level") + geom_count() + stat_smooth(method = "lm") + facet_wrap(~sex)
  
  q3_relation_g3_parent_sex = marrangeGrob(list(relation_g3_father_sex,  relation_g3_mother_sex), nrow = 1,ncol = 2,top = "Relationship Between G3, Sch, Parent Edu Lvl and Sex")
  q3_relation_g3_parent_sex
  ggsave(filename = paste("img/q3 - Relation Between G3, sex and Parents Edu Level.png",sep=""),q3_relation_g3_parent_sex,dpi = 1000,width = 10,height = 5)
}
relR3AndParentAndSex()

# Q4 Relationship Between AvgGrade, Failure and School
avgGradeAndFailure <- function() {
  graph <- ggplot(dataset, aes(failures, AvgGrade, colour = failures, group = failures)) +   geom_boxplot() +  geom_jitter(alpha = 0.3)  + 
    labs(title="Relation between AvgGrade, Failures and School") +
    ylab("Avg Result") +
    xlab("Failures")
  graph
 ggsave(filename = paste("img/Relationship Between AvgGrade, Failure and School.png",sep=""),graph,dpi = 1000,width = 10,height = 5) 
}
avgGradeAndFailure()

# https://ggplot2.tidyverse.org/reference/position_jitter.html

# Q5 Relationship Between G3, Health and Family Relation
relG3AndFamRelAndHealh <- function() {
  rel_g3_health <- ggplot(dataset, aes(health, AvgGrade, colour = health, group = health)) +   geom_boxplot() +  geom_jitter(alpha = 0.3) + 
    labs(title="Relation between G3 and Health") +
    ylab("G3 Result") +
    xlab("Health")
  
  
  rel_g3_famrel <- ggplot(dataset, aes(famrel, AvgGrade, colour = famrel, group = famrel)) +   geom_boxplot() +  geom_jitter(alpha = 0.3) + 
    labs(title="Relation between G3 and Family Relation") +
    ylab("G3 Result") +
    xlab("Family Relation")
  
  
  graph = marrangeGrob(list(rel_g3_health, rel_g3_famrel), nrow = 2,ncol = 1,top = "Relationship Between G3,  Health and Family Relation")
  graph
 ggsave(filename = paste("img/Relationship Between G3, Health and Family Relation.png",sep=""),graph,dpi = 1000,width = 10,height = 5)
  
}
relG3AndFamRelAndHealh()

# Q6 Relation Between G3 and Alcohol
relG3AndAlc <- function() {
  rel_g3_dalc <- ggplot(dataset, aes(Dalc, G3, colour = Dalc, group = Dalc)) +   geom_boxplot() +  geom_violin(alpha = 0)  + 
    labs(title="Relation between G3, Workday Alcohol") +
    ylab("G3 Result") +
    xlab("Weekday Alcohol")
  
  rel_g3_walc <- ggplot(dataset, aes(Walc, G3, colour = Walc, group = Walc)) +   geom_boxplot() +  geom_violin(alpha = 0) + 
    labs(title="Relation between G3, Weekend Alcohol") +
    ylab("G3 Result") +
    xlab("Weekend Alcohol")
  
  q6 = marrangeGrob(list(rel_g3_dalc, rel_g3_walc), nrow = 2,ncol = 1,top = "Relationship Between G3 and Alcohol")
  
  ggsave(filename = paste("img/Relation Between G3 and Alcohol.png",sep=""),q6,dpi = 1000,width = 10,height = 5)
  q6
}
relG3AndAlc()

# Q7 Relationship Between AvgGrade and Time Spend Events
relAvgGradeAndEvents <- function() {
  rel_g3_freetime <- ggplot(dataset, aes(freetime, AvgGrade, colour = freetime, group = freetime)) +   geom_boxplot() +  
    geom_violin(alpha=0) +  
    labs(title="Relation between AvgGrade and Freetime") +
    ylab("AvgGrade Result") +
    xlab("Freetime")
  
  rel_g3_goout <- ggplot(dataset, aes(goout, AvgGrade, colour = goout, group = goout)) +   geom_boxplot() +  
    geom_violin(alpha=0) +  
    labs(title="Relation between AvgGrade and Go Out Time") +
    ylab("AvgGrade Result") +
    xlab("Go Out Time")
  
  rel_g3_studytime <- ggplot(dataset, aes(studytime, AvgGrade, colour = studytime, group = studytime)) +   geom_boxplot() +  
    geom_violin(alpha=0) +  
    labs(title="Relation between AvgGrade and Studytime") +
    ylab("AvgGrade Result") +
    xlab("Studytime")
  
  rel_g3_traveltime <- ggplot(dataset, aes(traveltime, AvgGrade, colour = traveltime, group = traveltime)) +   geom_boxplot() +  
    geom_violin(alpha=0) +  
    labs(title="Relation between AvgGrade and Traveltime") +
    ylab("AvgGrade Result") +
    xlab("Traveltime")
  
  graph = marrangeGrob(list(rel_g3_goout, rel_g3_freetime, rel_g3_studytime, rel_g3_traveltime), nrow = 2,ncol = 2,top = "Relationship Between AvgGrade and Time Spend Events")
  graph
  ggsave(filename = paste("img/Relationship Between AvgGrade and Time Spend Events.png",sep=""),graph,dpi = 1000,width = 10,height = 5)
}
relAvgGradeAndEvents()

# Q8 Relationship Between G3 and Reason Join School Relation
rel_g3_reason <- function() {
  rel_g3_reason <- ggplot(dataset, aes(reason, G3, colour = reason, group = reason)) +   geom_boxplot() +  
    geom_violin(alpha=0) +  
    labs(title="Relation between G3 and Reason") +
    ylab("G3 Result") +
    xlab("Reason to Join School") + facet_wrap(~school)
  ggsave(filename = paste("img/Relationship Between G3 and Reason Join School Relation.png",sep=""),rel_g3_reason,dpi = 1000,width = 10,height = 5)
  
  rel_g3_reason
}
rel_g3_reason()

# Q9 Relationship Between Romantic, AvgGrade and Sex
romanticEffectStudentGrade <- function() {
  graph <- ggplot(dataset, aes(romantic, AvgGrade, colour = romantic, group = romantic)) +   geom_boxplot() +  geom_jitter(alpha = 0.3)  + 
    labs(title="Relation between Romantic and Student Grade") +
    ylab("Student Grade (G1, G2, G3)") +
    xlab("Romantic") + facet_wrap(~sex)
  ggsave(filename = paste("img/Relationship Between Romantic, AvgGrade and Sex.png",sep=""),graph,dpi = 1000,width = 10,height = 5) 
  graph
  }
romanticEffectStudentGrade()

# Q10 Relationship Between Travel Time ,G3, and Absence
relAbsAndTravel <- function () {
  rel_travel_time_n_absences <- ggplot(dataset, aes(traveltime, absences, colour = traveltime, group = traveltime)) +   geom_boxplot() +  geom_jitter(alpha = 0.3)  + 
    labs(title="Relation between Travel Time and Absences") +
    ylab("Absences") +
    xlab("Travel Time")
    
    
    rel_travel_time_n_g3 <- ggplot(dataset, aes(traveltime, G3, colour = traveltime, group = traveltime)) +   geom_boxplot() +  geom_jitter(alpha = 0.3)  + 
      labs(title="Relation between Travel Time and G3") +
      ylab("G3") +
      xlab("Travel Time") + facet_wrap(~school)
    graph = marrangeGrob(list(rel_travel_time_n_absences, rel_travel_time_n_g3), nrow = 2,ncol = 1,top = "Relationship Between Travel Time ,G3, and Absence")
    graph
    ggsave(filename = paste("img/Relationship Between Travel Time ,G3, and Absence.png",sep=""),graph,dpi = 1000,width = 10,height = 5) 
    
}
relAbsAndTravel()


# Q11 Relationship Between Age And Average Grade
relAgeAndResult <- function() {
   graph <- ggplot(dataset, aes(age, AvgGrade, colour = age, group = age)) +   geom_boxplot() +  geom_violin(alpha = 0.3)  + 
      labs(title="Relation between Age and Average Grade") +
      ylab("Average Grade") +
      xlab("Age")
   graph
   ggsave(filename = paste("img/Relationship Between Age And Average Grade.png",sep=""),graph,dpi = 1000,width = 10,height = 5) 
   
}
relAgeAndResult()

# Q12 Relationship Between Psatus And Family Relation
relPstatusAndFamrel <- function() {
  graph <- ggplot(dataset, aes(Pstatus, famrel, colour = Pstatus, group = Pstatus)) +   geom_boxplot() +  geom_violin(alpha = 0.3)  + 
    labs(title="Relation between Psatus and Family Relation") +
    ylab("Family Relation") +
    xlab("Is Living With Family")
  graph
  ggsave(filename = paste("img/Relationship Between Psatus And Family Relation.png",sep=""),graph,dpi = 1000,width = 10,height = 5) 
  
}
relPstatusAndFamrel()

