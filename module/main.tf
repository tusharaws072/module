 module "mysql" {
    source = "./modules/my_module"  
   
 }




 module "postgres" {
    source = "./mysql "
   
 }