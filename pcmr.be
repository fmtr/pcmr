var VERSION='0.0.0'
var CURRENT_LOW=1.0*1000
var POWER_LOW=1.0

def list_map(data, closure)
    var data_mapped=[]
    for item: data        
        data_mapped.push(closure(item))
    end
    return data_mapped
end

def tasmota_cmd(cmd)
    if classname(cmd)=='list'
        cmd=list_map(cmd,str)
        cmd=cmd.concat(' ')
    end
    return tasmota.cmd(cmd)
end

def apply_cals(current,power)    
    tasmota_cmd(['currentset',str(int(current))])
    tasmota_cmd(['powerset',str(int(power))])
end

def get_num_pm_powers()
    var energy_today_totals=tasmota.cmd('energytoday').find("EnergyToday",{}).find("Total",[])
    if type(energy_today_totals)=='real'
        energy_today_totals=[energy_today_totals]
    elif !size(energy_today_totals)
        raise "Power monitoring doesn't look to be enabled. Enable it first."
    end

    return size(energy_today_totals)
end
var NUM_PM_POWERS=get_num_pm_powers()

def power_callback_wrapper(pc, callback,value, trigger, message)

    if callback(pc)        

        var count_on=0
        for is_on: pc.get_powers()            
            count_on+=int(is_on)
        end        

        if !count_on
            print("Applying low power (standby) calibration: "+str({'current': CURRENT_LOW, 'power': POWER_LOW}))
            return apply_cals(CURRENT_LOW,POWER_LOW)
        end        

        var current=int(pc.current/count_on)
        var power=int(pc.power/count_on)
        
        print("Applying high power calibration: "+str({'current': current, 'power': power}))
        apply_cals(current,power)

    else

        print("Applying low power (standby) calibration: "+str({'current': CURRENT_LOW, 'power': POWER_LOW}))
        apply_cals(CURRENT_LOW,POWER_LOW)

    end
end

class PowerConfigurator

    static var CURRENT_LOW=1.0*1000
    static var POWER_LOW=1.0
    static var NUM_RELAYS=size(tasmota.get_power())

    var current
    var power
    var is_power_callback

    def init(current, power, is_power_callback)
        self.current=current
        self.power=power
        self.is_power_callback=is_power_callback
        self.register_rules()
    end

    def register_rules()
        for n : 0..size(tasmota.get_power())-1
            var closure=/value trigger message->power_callback_wrapper(self, self.is_power_callback,value, trigger, message)
            tasmota.add_rule('Power'+str(n+1), closure)
        end
    end

    def get_powers()

        var powers_t=tasmota.get_power()
        var powers=[]        

        for i: 0..NUM_PM_POWERS-1
            powers.push(powers_t[i])
        end

        return powers

    end


end

var pcmr = module("pcmr")
pcmr.VERSION=VERSION
pcmr.PowerConfigurator=PowerConfigurator
