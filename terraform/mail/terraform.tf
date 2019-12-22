module email {
  source      = "../modules/email"
  name = "email"
  persistant_storage_size = 22 #plus 8gb root vol = 30g, max free tier
  region = "us-east-1"
  ami_id = "ami-04b9e92b5572fa0d1" # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type
}
