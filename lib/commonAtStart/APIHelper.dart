//const API_IP = '192.168.3.102';
const API_IP = '192.168.0.118';
const PORT = 80;
const APIHOST = 'http://$API_IP:$PORT/chat_app/chat_app/pages/';

const FILES_IMG = 'http://$API_IP:$PORT/chat_app/chat_app/pages/assets/img/';
const FILES_MP3 = 'http://$API_IP:$PORT/chat_app/chat_app/pages/assets/audio/';
const FILES_ccd = 'http://$API_IP:$PORT/chat_app/chat_app/pages/assets/ccd/';

const IP = 'http://$API_IP:3000';

const AllowCcdToPatient = 'allowccdToPatient.php';

const formdataOfPatient = 'formdataOfPatient.php';

const getGroupsCreationData = 'getGroupsCreationData.php';

const getpatientFriend = 'getPatientList.php';

///'getPatientsFriends.php';
const referList = 'getrefer.php';
const refer = 'refer.php';
const rejectRequest = 'reject.php';
const addFriend = "addFriend.php";
const getAllDoctors = "getAllDoctors.php";
const profileUpdate = 'profileUpdate.php';
const uploaderURL = APIHOST + 'uploader.php';
const GetAllUsers = 'getAllUsers.php';
const UPDATESTATUS = 'updateStatus.php';
const SENDFRIENDREQUEST = "sendFriendReq.php";
const LOGIN = 'login.php';
const SIGNUP = 'signup.php';
const ASSETS = "getAssets.php";
const SINGLE_ROOMS = 'single_room.php';
const GROUP_ROOM = 'group_room.php';
const CHECK_STATUS_DOCTOR = 'check_doctor_status.php';
const GET_DOCTOR_LIST = 'doctor_lists.php';
const INVITE_PATIENT = 'invite_patient.php';
const GET_ALL_INVITATIONS = "getAllinvitation.php";
const Patient_DOCTOR_FRIENDS_LIST = 'friendDoctors_of_patients.php';
const get_person_Sending_list = 'get_person_Sending_list.php';
const updateFriendRequest = 'updateFriendRequest.php';
const sendFriendReq = 'sendFriendReq.php';
const UPLOADCHAT = 'chats.php';
const getChat = 'getChat.php';
const onDownload = 'onDownload.php';

///doctor
const uploadCCD = "uploadccd.php";

///

String status = '';
int otp = 0;
const EVENT_DOCTOR_STATUS = 'doctorApproval';
const EVENT_MSG = 'SEND_MSG';
const EVENT_ONLINE = 'ONLINE';
const EVENT_SEND_NUMBER = 'SEND_NUMBER';
const EVENT_LOGOUT = 'LOGOUT';
const EVENT_CHECK_CONNECT = 'EVENT_CHECK_CONNECT';
const EVENT_ADD_NUMBER = 'EVENT_ADD_NUMBER';

///db
const ROOMLIST = 'ROOMLIST';
const SINGLECHAT = 'SINGLECHAT';
const MESSAGE = 'MESSAGE';

const seprateString = '_dif123dif_';
//////////db
const folderName = 'chatassets';
const fileChecker = '_chatfile_';
