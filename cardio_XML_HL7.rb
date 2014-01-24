#!/usr/bin/ruby 


require 'date'
require 'ruby-hl7'
require 'rexml/document'
require 'socket'
include REXML


unless ARGV.length == 1
  puts "\n"
  puts "*********************************************************************"
  puts "*** Please make sure that you have the right number of arguments! ***"
  puts "*** Usage: ruby cardio_XML_HL7.rb InputFile.xml                   ***"
  puts "*********************************************************************\n\n"
  exit
end


# Create the empty HL7 message
msg = HL7::Message.new

#create an empty segments
msh = HL7::Message::Segment::MSH.new
pid = HL7::Message::Segment::PID.new
obr = HL7::Message::Segment::OBR.new
obx1 = HL7::Message::Segment::OBX.new
obx2 = HL7::Message::Segment::OBX.new
obx3 = HL7::Message::Segment::OBX.new
obx4 = HL7::Message::Segment::OBX.new
obx5 = HL7::Message::Segment::OBX.new
obx6 = HL7::Message::Segment::OBX.new
obx7 = HL7::Message::Segment::OBX.new
obx8 = HL7::Message::Segment::OBX.new
obx9 = HL7::Message::Segment::OBX.new
obx10 = HL7::Message::Segment::OBX.new
obx11 = HL7::Message::Segment::OBX.new
obx12 = HL7::Message::Segment::OBX.new
obx13 = HL7::Message::Segment::OBX.new
obx14 = HL7::Message::Segment::OBX.new
obx15 = HL7::Message::Segment::OBX.new
obx16 = HL7::Message::Segment::OBX.new
obx17 = HL7::Message::Segment::OBX.new
obx18 = HL7::Message::Segment::OBX.new
obx19 = HL7::Message::Segment::OBX.new


# Load Document
filename = ARGV[0]
patient = (Document.new File.new filename).root

# Patient information
# Demographics
$pat_pid = patient.root.elements["/CardiologyXML/PatientInfo"].elements["PID"].text
$family_name = patient.root.elements["/CardiologyXML/PatientInfo/Name"].elements["FamilyName"].text
$given_name = patient.root.elements["/CardiologyXML/PatientInfo/Name"].elements["GivenName"].text
age = patient.root.elements["/CardiologyXML/PatientInfo"].elements["Age"].text
$day_of_bday = patient.root.elements["/CardiologyXML/PatientInfo/BirthDateTime"].elements["Day"].text
$month_of_bday = patient.root.elements["/CardiologyXML/PatientInfo/BirthDateTime"].elements["Month"].text
$year_of_bday = patient.root.elements["/CardiologyXML/PatientInfo/BirthDateTime"].elements["Year"].text
$gender = patient.root.elements["/CardiologyXML/PatientInfo"].elements["Gender"].text
height = patient.root.elements["/CardiologyXML/PatientInfo/Height"].text
weight = patient.root.elements["/CardiologyXML/PatientInfo/Weight"].text

# Measurements
#
#sys_bp = patient.root.elements["/CardiologyXML/PatientVisit"].elements["SysBP"].text
#dia_bp = patient.root.elements["/CardiologyXML/PatientVisit"].elements["DiaBP"].text

$ventricular_rate = patient.root.elements["/CardiologyXML/RestingECGMeasurements/VentricularRate"].text
$pq_interval = patient.root.elements["/CardiologyXML/RestingECGMeasurements/PQInterval"].text
$p_duration = patient.root.elements["/CardiologyXML/RestingECGMeasurements/PDuration"].text
$qrs_duration = patient.root.elements["/CardiologyXML/RestingECGMeasurements/QRSDuration"].text
$qrs_count = patient.root.elements["/CardiologyXML/RestingECGMeasurements/QRSNum"].text
$qt_interval = patient.root.elements["/CardiologyXML/RestingECGMeasurements/QTInterval"].text
$qtc_interval = patient.root.elements["/CardiologyXML/RestingECGMeasurements/QTCInterval"].text
$rr_interval = patient.root.elements["/CardiologyXML/RestingECGMeasurements/RRInterval"].text
$pp_interval = patient.root.elements["/CardiologyXML/RestingECGMeasurements/PPInterval"].text
$pa_axis = patient.root.elements["/CardiologyXML/RestingECGMeasurements/PAxis"].text
$ra_axis = patient.root.elements["/CardiologyXML/RestingECGMeasurements/RAxis"].text
$ta_axis = patient.root.elements["/CardiologyXML/RestingECGMeasurements/TAxis"].text
$p_onset = patient.root.elements["/CardiologyXML/RestingECGMeasurements/POnset"].text
$p_offset = patient.root.elements["/CardiologyXML/RestingECGMeasurements/POffset"].text
$q_onset = patient.root.elements["/CardiologyXML/RestingECGMeasurements/QOnset"].text
$q_offset = patient.root.elements["/CardiologyXML/RestingECGMeasurements/QOffset"].text
$t_offset = patient.root.elements["/CardiologyXML/RestingECGMeasurements/TOffset"].text

#
# Interpretation
#
#$diagnosis = patient.root.elements["/CardiologyXML/Interpretation/Diagnosis/DiagnosisText"].texts()
#$diagnosis = patient.root.elements["/CardiologyXML/Interpretation/Diagnosis/DiagnosisText"].elements.map(&:to_s) 
#patient.root.elements.each("/CardiologyXML/Interpretation/Diagnosis/DiagnosisText") { |element| 
#diagnostic.push = element.text
#}


def dateofBirth()

   date = $year_of_bday + $month_of_bday.to_s.rjust(2, '0') + $day_of_bday.to_s.rjust(2, '0')
   return date

end

def genderCheck()

     if $gender == "FEMALE"
	     sex = "F"
     elsif $gender == "MALE"
	     sex = "M"
     else
	     sex = "U"
     end

     return sex

end	

def createMSH(msh)

        t = Time.now

        msh.enc_chars = '^~\&'
        msh.sending_app = 'CardioXML2HL7'
        msh.sending_facility = 'Hospital_A'
        msh.recv_app = 'MIRTH'
        msh.recv_facility = 'Hospital_Z'
        msh.time = t.strftime("%Y%m%d%H%M%S")
        msh.security = ''
        msh.message_type = 'ORU'
        msh.message_control_id = ''
        msh.processing_id = 'P'
        msh.version_id = '2.3'
        msh.seq = ''
        msh.continue_ptr = ''
        msh.accept_ack_type = 'NE'

end

def createPID(pid)

        t = Time.now
        t.strftime("%Y%m%d%H%M%S")
        ssn = ''
        dob = ''
        #dob = dob.gsub!(/\D/, "")

        pid.set_id = '1'
        pid.patient_id =  ''
        pid.patient_id_list = $pat_pid 
        pid.alt_patient_id = ''
        pid.patient_name = $family_name.rstrip + "^" + $given_name.rstrip + "^" + "^" + "^" + "^" +
        pid.mother_maiden_name = ''
        pid.patient_dob = dateofBirth() 
        pid.admin_sex = genderCheck() 
        pid.patient_alias = ''
        pid.race = ''

        return pid
end


def createOBR(obr)

        t = Time.now

        obr.set_id = '1'
        obr.placer_order_number = ''
        obr.filler_order_number = ''
        obr.universal_service_id = 'R_ECG'
        obr.priority = ''
        obr.requested_date = '' 
        obr.observation_date = t.strftime("%Y%m%d%H%M%S") 
        obr.observation_end_date = ''
        obr.collection_volume = ''
        obr.collector_identifier = ''
        obr.specimen_action_code = ''
        obr.danger_code = ''
        obr.relevant_clinical_info = ''
        obr.specimen_received_date = t.strftime("%Y%m%d%H%M%S")
        obr.specimen_source = ''
        obr.ordering_provider = ''
        obr.order_callback_phone_number = ''
        obr.placer_field_1 = 'EK' 
        obr.placer_field_2 = ''
        obr.filler_field_1 = ''
        obr.filler_field_2 = ''
        obr.results_status_change_date = t.strftime("%Y%m%d%H%M%S") 
        obr.charge_to_practice = ''
        obr.diagnostic_serv_sect_id = ''
        obr.result_status = 'F'

end

def createOBX01(obx1)

        obx1.set_id = '1'
        obx1.value_type = 'ST'
        obx1.observation_id = 'Acquisition Device'
        obx1.observation_sub_id = ''
        obx1.observation_value = 'CSYS'
        obx1.units = ''
        obx1.references_range = ''
        obx1.abnormal_flags = ''
        obx1.probability = ''
        obx1.nature_of_abnormal_test = ''
        obx1.observation_result_status = 'F'

end

def createOBX02(obx2)

        obx2.set_id = '2'
        obx2.value_type = 'ST'
        obx2.observation_id = 'Test^RECG'
        obx2.observation_sub_id = ''
        obx2.observation_value = ''
        obx2.units = ''
        obx2.references_range = ''
        obx2.abnormal_flags = ''
        obx2.probability = ''
        obx2.nature_of_abnormal_test = ''
        obx2.observation_result_status = 'F'

end

def createOBX03(obx3)

        obx3.set_id = '3'
        obx3.value_type = 'ST'
        obx3.observation_id = 'Systolic BP'
        obx3.observation_sub_id = ''
        obx3.observation_value = ''
        obx3.units = ''
        obx3.references_range = ''
        obx3.abnormal_flags = ''
        obx3.probability = ''
        obx3.nature_of_abnormal_test = ''
        obx3.observation_result_status = 'F'

end

def createOBX04(obx4)

        obx4.set_id = '4'
        obx4.value_type = 'ST'
        obx4.observation_id = 'Diasystolic BP'
        obx4.observation_sub_id = ''
        obx4.observation_value = ''
        obx4.units = ''
        obx4.references_range = ''
        obx4.abnormal_flags = ''
        obx4.probability = ''
        obx4.nature_of_abnormal_test = ''
        obx4.observation_result_status = 'F'

end

def createOBX05(obx5)

        obx5.set_id = '5'
        obx5.value_type = 'ST'
        obx5.observation_id = 'Ventricular Rate'
        obx5.observation_sub_id = ''
        obx5.observation_value = $ventricular_rate
        obx5.units = 'BPM'
        obx5.references_range = ''
        obx5.abnormal_flags = ''
        obx5.probability = ''
        obx5.nature_of_abnormal_test = ''
        obx5.observation_result_status = 'F'

end

def createOBX06(obx6)

        obx6.set_id = '6'
        obx6.value_type = 'ST'
        obx6.observation_id = 'QRS Duration'
        obx6.observation_sub_id = ''
        obx6.observation_value = $qrs_duration
        obx6.units = 'ms'
        obx6.references_range = ''
        obx6.abnormal_flags = ''
        obx6.probability = ''
        obx6.nature_of_abnormal_test = ''
        obx6.observation_result_status = 'F'

end

def createOBX07(obx7)

        obx7.set_id = '7'
        obx7.value_type = 'ST'
        obx7.observation_id = 'Q-T Interval'
        obx7.observation_sub_id = ''
        obx7.observation_value = $qt_interval
        obx7.units = 'ms'
        obx7.references_range = ''
        obx7.abnormal_flags = ''
        obx7.probability = ''
        obx7.nature_of_abnormal_test = ''
        obx7.observation_result_status = 'F'

end

def createOBX08(obx8)

        obx8.set_id = '8'
        obx8.value_type = 'ST'
        obx8.observation_id = 'P Axis'
        obx8.observation_sub_id = ''
        obx8.observation_value = $pa_axis 
        obx8.units = 'degrees'
        obx8.references_range = ''
        obx8.abnormal_flags = ''
        obx8.probability = ''
        obx8.nature_of_abnormal_test = ''
        obx8.observation_result_status = 'F'

end

def createOBX09(obx9)

        obx9.set_id = '3'
        obx9.value_type = 'ST'
        obx9.observation_id = 'R Axis'
        obx9.observation_sub_id = ''
        obx9.observation_value = $ra_axis 
        obx9.units = 'degrees'
        obx9.references_range = ''
        obx9.abnormal_flags = ''
        obx9.probability = ''
        obx9.nature_of_abnormal_test = ''
        obx9.observation_result_status = 'F'

end

def createOBX10(obx10)

        obx10.set_id = '10'
        obx10.value_type = 'ST'
        obx10.observation_id = 'T Axis'
        obx10.observation_sub_id = ''
        obx10.observation_value = $ta_axis 
        obx10.units = 'degrees'
        obx10.references_range = ''
        obx10.abnormal_flags = ''
        obx10.probability = ''
        obx10.nature_of_abnormal_test = ''
        obx10.observation_result_status = 'F'

end

def createOBX11(obx11)

        obx11.set_id = '11'
        obx11.value_type = 'ST'
        obx11.observation_id = 'QRS Count '
        obx11.observation_sub_id = ''
        obx11.observation_value = $qrs_count
        obx11.units = ''
        obx11.references_range = ''
        obx11.abnormal_flags = ''
        obx11.probability = ''
        obx11.nature_of_abnormal_test = ''
        obx11.observation_result_status = 'F'

end

def createOBX12(obx12)

        obx12.set_id = '12'
        obx12.value_type = 'ST'
        obx12.observation_id = 'Q Onset'
        obx12.observation_sub_id = ''
        obx12.observation_value = $q_onset
        obx12.units = 'ms'
        obx12.references_range = ''
        obx12.abnormal_flags = ''
        obx12.probability = ''
        obx12.nature_of_abnormal_test = ''
        obx12.observation_result_status = 'F'

end

def createOBX13(obx13)

        obx13.set_id = '13'
        obx13.value_type = 'ST'
        obx13.observation_id = 'Q Offset'
        obx13.observation_sub_id = ''
        obx13.observation_value = $q_offset
        obx13.units = 'ms'
        obx13.references_range = ''
        obx13.abnormal_flags = ''
        obx13.probability = ''
        obx13.nature_of_abnormal_test = ''
        obx13.observation_result_status = 'F'

end

def createOBX14(obx14)

        obx14.set_id = '14'
        obx14.value_type = 'ST'
        obx14.observation_id = 'P Offset'
        obx14.observation_sub_id = ''
        obx14.observation_value = $p_offset
        obx14.units = 'ms'
        obx14.references_range = ''
        obx14.abnormal_flags = ''
        obx14.probability = ''
        obx14.nature_of_abnormal_test = ''
        obx14.observation_result_status = 'F'

end

def createOBX15(obx15)

        obx15.set_id = '15'
        obx15.value_type = 'ST'
        obx15.observation_id = 'P Onset'
        obx15.observation_sub_id = ''
        obx15.observation_value = $p_onset
        obx15.units = 'ms'
        obx15.references_range = ''
        obx15.abnormal_flags = ''
        obx15.probability = ''
        obx15.nature_of_abnormal_test = ''
        obx15.observation_result_status = 'F'

end

def createOBX16(obx16)

        obx16.set_id = '16'
        obx16.value_type = 'ST'
        obx16.observation_id = 'T Offset'
        obx16.observation_sub_id = ''
        obx16.observation_value = $t_offset
        obx16.units = 'ms'
        obx16.references_range = ''
        obx16.abnormal_flags = ''
        obx16.probability = ''
        obx16.nature_of_abnormal_test = ''
        obx16.observation_result_status = 'F'

end

def createOBX17(obx17)

        obx17.set_id = '17'
        obx17.value_type = 'ST'
        obx17.observation_id = 'PP Interval '
        obx17.observation_sub_id = ''
        obx17.observation_value = $pp_interval
        obx17.units = 'ms'
        obx17.references_range = ''
        obx17.abnormal_flags = ''
        obx17.probability = ''
        obx17.nature_of_abnormal_test = ''
        obx17.observation_result_status = 'F'

end

def createOBX18(obx18)

        obx18.set_id = '18'
        obx18.value_type = 'ST'
        obx18.observation_id = 'RR Interval '
        obx18.observation_sub_id = ''
        obx18.observation_value = $rr_interval
        obx18.units = 'ms'
        obx18.references_range = ''
        obx18.abnormal_flags = ''
        obx18.probability = ''
        obx18.nature_of_abnormal_test = ''
        obx18.observation_result_status = 'F'

end

def createOBX19(obx19)

        obx19.set_id = '19'
        obx19.value_type = 'ST'
        obx19.observation_id = 'Interpretation'
        obx19.observation_sub_id = ''
        obx19.observation_value = 'Diagnosis: '
        obx19.units = ''
        obx19.references_range = ''
        obx19.abnormal_flags = ''
        obx19.probability = ''
        obx19.nature_of_abnormal_test = ''
        obx19.observation_result_status = 'F'

end


    createMSH(msh)
    createPID(pid)
    createOBR(obr)
    createOBX01(obx1)
    createOBX02(obx2)   
    createOBX03(obx3)
    createOBX04(obx4) 
    createOBX05(obx5)
    createOBX06(obx6) 
    createOBX07(obx7)
    createOBX08(obx8)   
    createOBX09(obx9)
    createOBX10(obx10) 
    createOBX11(obx11)
    createOBX12(obx12) 
    createOBX13(obx13)
    createOBX14(obx14)   
    createOBX15(obx15)
    createOBX16(obx16) 
    createOBX17(obx17)
    createOBX18(obx18) 
    createOBX19(obx19)


    msg << msh
    msg << pid
    msg << obr
    msg << obx1
    msg << obx2
    msg << obx3
    msg << obx4
    msg << obx5
    msg << obx6
    msg << obx7
    msg << obx8
    msg << obx9
    msg << obx10
    msg << obx11
    msg << obx12
    msg << obx13
    msg << obx14
    msg << obx15
    msg << obx16
    msg << obx17
    msg << obx18
    msg << obx19


#To send to screen
#puts msg.to_s

#To send message via TCP/IP
soc = TCPSocket.open( "192.168.1.134", 6661 )
soc.write msg.to_s
soc.close
