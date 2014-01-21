#ifndef __SVPN_SDK_H__
#define __SVPN_SDK_H__

/*******************************************************************
 
 注意：以下接口调用均为阻塞接口调用，请使用者加以注意！！！
 
 *******************************************************************/

#include <stdint.h>
#include <sys/types.h>
#include "sdkheader.h"

#ifdef __cplusplus
extern "C" {
#endif //__cplusplus

    /**
     * @功能 初始化一个VPN调用
     * @param vpnCallback一个VPN的回调函数，可以为NULL，如果为NULL则没有回调函数。注意
     *         此回调函数在新开的线程，请调用者注意线程安全的问题
     * @param vpn vpn的IP地址，必须是IP的网络序
     * @param port 端口的网络序
	 *
     * @return 无
     **/
    int vpn_init(const VPN_CALL_BACK callback, const uint32_t vpn, const uint16_t port);
	
    /**
     * @功能 设置vpn登录的属性
     * @param key[in] 不能为空，为上边以PORPERTY_开头的宏
     * @param value[in] 属性的值,可以为NULL功""
	 *
	 * @return 无
     **/
    void vpn_set_login_param(const char* key, const char* value);
	
    /**
     * @清理vqpn登录的属性
     * @param key[in] 不能为空，为上边以PORPERTY_开头的宏
     **/
    void vpn_clear_login_param(const char* key);
    
    /**
     * @功能 获取vpn登录的属性
     * @param key[in] 不能为空，为上边以PORPERTY_开头的宏
     * @param value[out] 属性的值,
     * @param value_lenth[in/out] value 的长度,by Bytes。返回实际长度
	 *
	 * @return 如果不存在，memset(value,0,value_length) return NULL;
     *         如果存在但长度不够 strncpy(value,out_value,value_length) return NULL;
     *         如果正确，strncpy(value,out_value,value_length) return value;
     *         如果参数错误，return NULL;
     **/
	void* vpn_get_login_param(const char* key,void* value,uint32_t * value_length);
    
    /**
     * @功能 登录vpn
     * @param authType 认证类型
	 *
     * @return 是否登录成功。如果失败后，可以调用geterr获取到失败原因
     **/
    int vpn_login(const int authType);

    /**
     * @功能 注销VPN
	 * 
	 * @return 成功返回true，失败返回false
     **/
    int vpn_logout();
    
    /**
     * @功能 设置获取图形验证码CALLBACK
     * @param callback
     **/
    void vpn_set_rnd_code_call_back(RND_CODE_CALL_BACK callback);
    
    /**
     * @功能 获取图形验证码
     **/
    int vpn_get_rnd_code();
	
    /**
     * @功能 退出程序前的调用的函数，只是为了把init设置的callBack置为空，调用此函数后不再有CallBack回调了
	 *
	 * @return 成功返回true，失败返回false
     **/
    int vpn_quit();
	
	/**
     * @功能 获取当前VPN的状态
	 *
	 * @return 当前VPN的状态
     **/
    VPN_STATUS vpn_query_status();
	
    /**
     * @功能 获取硬件特征码
	 *
	 * @return 硬件特征码，注意可能获取失败。失败时返回NULL
     **/
    char* vpn_query_hardid();
	
    /**
     * @功能 错误码信息
	 *
     * @return 错误字符串
     **/
    const char * vpn_geterr();
	
	/**
     * @功能 设置错误码信息
     **/
    void vpn_seterr(const char* err);
	
    /**
     * @功能 取硬件特征码时不取网卡的值
     **/
    void set_no_eth_hardid();
	
	/**
     * @功能 设置DNS服务器的地址
	 *       注意必须为有效的DNS服务IP地址字符串，
	 *		 如果不是有效的IP地址，则会被丢弃
	 * @return 无返回值
     **/
    void set_dns_server(const char *dnsServer);
    
    /**
     * @功能 设置文件加密规则,注意rules可以用';'号隔开，设置多条规则，
     *       例如: *／Documnet／*;*／file／*,其中就是两条规则
     **/
    void set_file_crypt_rules(const char *rules);
    
    /**
     * @功能 设置非加密文件规则,注意rules可以用';'号隔开，设置多条规则，
     *       例如: *／Documnet／*;*／file／*,其中就是两条规则
     **/
    void set_file_exclude_crypt_rules(const char *rules);
    
	/**
     * @功能 获取版本号
	 *       
	 * @return 最新打出SDK的版本号
     **/
	const char *get_version();
    
/*********************************************************************/
	uint32_t get_vpn_host();
	uint16_t get_vpn_port(); 
	uint16_t get_server_socket_port();
	uint16_t get_server_socket6_port();
	uint16_t get_dns_server_port();
	
#ifdef __cplusplus
}
#endif //__cplusplus

#endif //__SVPN_SDK_H__

